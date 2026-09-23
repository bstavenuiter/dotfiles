local M = {}

local curl = require("plenary.curl")

local function git(dir, cmd)
    local result = vim.fn.system("git -C " .. vim.fn.shellescape(dir) .. " " .. cmd)
    if vim.v.shell_error ~= 0 then
        return nil
    end
    return vim.trim(result)
end

-- Directory to run git from: the current buffer's directory when it maps to a
-- real file on disk, otherwise the editor's working directory. Special buffers
-- (terminals, oil://, scratch, dashboards) have a name but no real path, so we
-- fall back to cwd rather than trusting a bogus directory.
local function context_dir()
    local buf = vim.api.nvim_buf_get_name(0)
    if buf ~= "" and vim.fn.filereadable(buf) == 1 then
        return vim.fn.fnamemodify(buf, ":h")
    end
    return vim.fn.getcwd()
end

-- Resolve the git-backed directory for the current context, or nil (warning).
local function repo_dir()
    local dir = context_dir()
    if git(dir, "rev-parse --is-inside-work-tree") ~= "true" then
        vim.notify("Not inside a git repository", vim.log.levels.WARN)
        return nil
    end
    return dir
end

local function project_path(dir)
    local remote = git(dir, "remote get-url origin")
    if not remote then
        vim.notify("No git remote 'origin' found", vim.log.levels.WARN)
        return nil
    end

    -- SSH: git@gitlab.example.com:group/project.git
    local path = remote:match("^git@[^:]+:(.+)$")
    -- HTTPS: https://gitlab.example.com/group/project.git
    if not path then
        path = remote:match("^https?://[^/]+/(.+)$")
    end

    if not path then
        vim.notify("Could not parse remote URL: " .. remote, vim.log.levels.WARN)
        return nil
    end

    return path:gsub("%.git$", "")
end

local function branch(dir)
    local b = git(dir, "rev-parse --abbrev-ref HEAD")
    if not b or b == "HEAD" then
        vim.notify("Detached HEAD — cannot determine branch", vim.log.levels.WARN)
        return nil
    end
    return b
end

local function base_url()
    if not M._config.host or M._config.host == "" then
        vim.notify("GITLAB_HOST not set. Export it or pass host to setup()", vim.log.levels.WARN)
        return nil
    end
    return "https://" .. M._config.host
end

local function project_url(dir)
    local base = base_url()
    if not base then return nil end
    local path = project_path(dir)
    if not path then return nil end
    return base .. "/" .. path
end

local function open(url)
    if url then
        vim.ui.open(url)
    end
end

-- Authenticated GET against the GitLab REST API. Returns decoded JSON or nil.
local function api_get(path, query)
    local host = (M._config and M._config.host) or os.getenv("GITLAB_HOST") or ""
    if host == "" then
        vim.notify("GITLAB_HOST not set", vim.log.levels.WARN)
        return nil
    end
    local token = os.getenv("GITLAB_TOKEN")
    if not token or token == "" then
        vim.notify("GITLAB_TOKEN not set", vim.log.levels.WARN)
        return nil
    end
    local res = curl.get("https://" .. host .. "/api/v4/" .. path, {
        headers = { ["PRIVATE-TOKEN"] = token },
        query = query,
    })
    if not res or res.status < 200 or res.status >= 300 then
        return nil
    end
    return vim.json.decode(res.body)
end

-- The three date strings the events API needs for a single day. `after` and
-- `before` are exclusive, so they bracket the target day on either side.
local function day_window(offset)
    local target = os.date("*t")
    target.day = target.day + (offset or 0)
    local t = os.time(target)
    return os.date("%Y-%m-%d", t),
        os.date("%Y-%m-%d", t - 86400),
        os.date("%Y-%m-%d", t + 86400)
end

-- First JIRA-style key (e.g. SHR-3278) found in a title, or nil.
local function ticket_of(title)
    return title and title:match("([A-Z][A-Z]+%-%d+)")
end

local ACTION_LABELS = {
    ["accepted"] = "merged",
    ["approved"] = "approved",
    ["closed"] = "closed",
    ["opened"] = "opened",
    ["commented on"] = "commented",
    ["pushed to"] = "pushed",
}

-- Merge requests I acted on during the given day offset (0 = today, -1 =
-- yesterday). Each item is classified by authorship: "work" if I authored the
-- MR, "review" otherwise. Returns { ticket, title, url, ref, state, category,
-- actions }.
M.worked_on = function(offset)
    local _, after, before = day_window(offset)
    local events = api_get("events", { after = after, before = before, per_page = 100 })
    if not events then return {} end

    local me = api_get("user")
    me = me and me.username

    -- Group events by merge request, collecting the distinct actions I took.
    local mrs, order = {}, {}
    for _, ev in ipairs(events) do
        local pid, iid
        if ev.target_type == "MergeRequest" then
            pid, iid = ev.project_id, ev.target_iid
        elseif ev.note and ev.note.noteable_type == "MergeRequest" then
            pid, iid = ev.project_id, ev.note.noteable_iid
        end
        if pid and iid then
            local key = pid .. ":" .. iid
            if not mrs[key] then
                mrs[key] = { pid = pid, iid = iid, actions = {} }
                table.insert(order, key)
            end
            mrs[key].actions[ACTION_LABELS[ev.action_name] or ev.action_name] = true
        end
    end

    local items = {}
    for _, key in ipairs(order) do
        local mr = mrs[key]
        local detail = api_get(string.format("projects/%d/merge_requests/%d", mr.pid, mr.iid))
        if detail then
            local actions = {}
            for a in pairs(mr.actions) do table.insert(actions, a) end
            table.sort(actions)
            table.insert(items, {
                ticket = ticket_of(detail.title),
                title = detail.title,
                url = detail.web_url,
                ref = (detail.references and detail.references.short) or ("!" .. mr.iid),
                state = detail.state,
                category = (me and detail.author and detail.author.username == me) and "work" or "review",
                actions = table.concat(actions, ", "),
            })
        end
    end
    return items
end

local commands = {
    GitlabMR = function()
        local dir = repo_dir()
        if not dir then return end
        local url = project_url(dir)
        local b = branch(dir)
        if url and b then
            open(url .. "/-/merge_requests?scope=all&state=opened&source_branch=" .. b)
        end
    end,
    GitlabRepo = function()
        local dir = repo_dir()
        if not dir then return end
        open(project_url(dir))
    end,
    GitlabMRs = function()
        local dir = repo_dir()
        if not dir then return end
        local url = project_url(dir)
        if url then open(url .. "/-/merge_requests") end
    end,
    GitlabPipeline = function()
        local dir = repo_dir()
        if not dir then return end
        local url = project_url(dir)
        if url then open(url .. "/-/pipelines") end
    end,
    GitlabVariables = function()
        local dir = repo_dir()
        if not dir then return end
        local url = project_url(dir)
        if url then open(url .. "/-/settings/ci_cd") end
    end,
    GitlabTags = function()
        local dir = repo_dir()
        if not dir then return end
        local url = project_url(dir)
        if url then open(url .. "/-/tags") end
    end,
    GitlabFile = function(opts)
        local dir = repo_dir()
        if not dir then return end
        local url = project_url(dir)
        local b = branch(dir)
        if not url or not b then return end

        local buf = vim.api.nvim_buf_get_name(0)
        if buf == "" then
            vim.notify("No file open", vim.log.levels.WARN)
            return
        end

        local root = git(dir, "rev-parse --show-toplevel")
        if not root then return end

        local rel = buf:sub(#root + 2)
        local anchor
        if opts.range > 0 then
            anchor = "#L" .. opts.line1 .. "-" .. opts.line2
        else
            anchor = "#L" .. vim.api.nvim_win_get_cursor(0)[1]
        end
        open(url .. "/-/blob/" .. b .. "/" .. rel .. anchor)
    end,
}

M.setup = function(config)
    config = config or {}
    M._config = vim.tbl_deep_extend("force", {
        host = os.getenv("GITLAB_HOST") or "",
    }, config)

    for name, fn in pairs(commands) do
        local cmd_opts = {}
        if name == "GitlabFile" then
            cmd_opts.range = true
        end
        vim.api.nvim_create_user_command(name, fn, cmd_opts)
    end
end

return M
