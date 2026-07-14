local M = {}

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
