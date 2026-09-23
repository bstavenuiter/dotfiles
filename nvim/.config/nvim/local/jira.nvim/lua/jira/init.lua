local M = {}

local curl = require("plenary.curl")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local function handle_response(response)
    return {
        data = vim.fn.json_decode(response.body),
        status = response.status,
    }
end

local function make_request(method, endpoint, opts)
    opts = opts or {}
    local request_opts = vim.tbl_deep_extend("force", {
        auth = M._config.username .. ":" .. M._config.token,
        headers = {
            content_type = "application/json",
        },
    }, opts)

    local response = curl[method](
        M._config.base_url .. "/rest/api/3/" .. endpoint,
        -- /rest/api/3/search/jql
        request_opts
    )

    return handle_response(response)
end

local function escape_string(str)
    return string.gsub(str, "\"", "\\\"")
end

local function construct_jql(opts)
    opts = opts or {}

    if opts.jql ~= nil then
        return opts.jql
    end

    local frag = {}

    if opts.text ~= "" then
        table.insert(frag, "summary ~ \"" .. escape_string(opts.text) .. "\"")
    end

    for _, key in ipairs({ 'project', 'assignee', 'reporter', 'creator', 'watcher', 'type' }) do
        if opts[key] then
            local value = opts[key]
            -- Check if there's multiple values
            -- multiple -> IN search
            -- single -> IS search
            -- Split value by comma to allow for multiple values being passed

            local args = {
                count = 0,
                items = {}
            }
            for i in string.gmatch(value, '([^,]+)') do
                table.insert(args.items, i)
                args.count = args.count + 1
            end

            if args.count > 1 then
                table.insert(frag, key .. " in (" .. table.concat(args.items, ",") .. ")")
            else
                table.insert(frag, key .. " = \"" .. escape_string(value) .. "\"")
            end
        end
    end

    return table.concat(frag, " AND ")
end

M.get_browse_url = function(key)
    return M._config.base_url .. "/browse/" .. key
end

M.projects = function(search_phrase)
    local res
    if search_phrase == "" then
        local endpoint = "project"
        res = make_request("get", endpoint)
    else
        local endpoint = "projects/picker"
        res = make_request("get", endpoint, {
            query = { query = search_phrase }
        })
    end

    local entries = {}
    for _, v in pairs(res.data) do
        table.insert(entries, {
            key = v.key,
            name = v.name
        })
    end

    return {
        items = entries,
        maxResults = res.data.maxResults,
        startAt = res.data.startAt
    }
end

M.search = function(search_phrase, opts)
    -- Validate config

    local jql = construct_jql(vim.tbl_extend("keep", {
        jql = search_phrase
    }, opts))

    local endpoint = "search/jql"
    -- Paginate?
    local payload = {
        jql = jql,
        -- startAt = 0,
        maxResults = (opts and opts.maxResults) or 10,
        fields = {
            --     "id",
            --     "key",
            "summary",
            --     "status",
            --     "assignee",
            --     "creator",
            --     "reporter",
            "description",
            --     "issuetype",
            --     "priority",
        }
    }

    local res = make_request("post", endpoint, {
        body = vim.fn.json_encode(payload)
    })

    -- Validate success of request
    if res.status ~= 200 then
        vim.notify(vim.inspect(res.data.errorMessages), vim.log.levels.ERROR)
        return {
            items = {}
        }
    end

    -- Format to table
    local entries = {}
    if res.data.issues then
        for _, v in pairs(res.data.issues) do
            local f = v.fields

            local description = ExtractText(f.description)

            table.insert(entries, {
                id = v.id,
                key = v.key,
                description = description, --f.description,
                summary = f.summary,
                -- created = f.created,
                -- assignee = f.assignee ~= vim.NIL and f.assignee.displayName,
                -- creator = f.creator ~= vim.NIL and f.creator.displayName,
                -- reporter = f.reporter ~= vim.NIL and f.reporter.displayName,
                -- priority = f.priority ~= vim.NIL and f.priority.name,
                -- issuetype = f.issuetype ~= vim.NIL and f.issuetype.name,
                -- status = f.status ~= vim.NIL and f.status.name
            })
        end
    end

    return {
        items = entries,
        maxResults = res.data.maxResults,
        startAt = res.data.startAt
    }
end


-- Function to recursively extract text as markdown from Jira ADF
function ExtractText(node, context)
    if not node or node == vim.NIL then return "" end
    context = context or {}
    local result = ""

    if node.type == "text" then
        local text = node.text or ""
        if node.marks then
            for _, mark in ipairs(node.marks) do
                if mark.type == "strong" then
                    text = "**" .. text .. "**"
                elseif mark.type == "em" then
                    text = "_" .. text .. "_"
                elseif mark.type == "code" then
                    text = "`" .. text .. "`"
                elseif mark.type == "strike" then
                    text = "~~" .. text .. "~~"
                end
            end
        end
        return text
    end

    if node.type == "heading" then
        local level = node.attrs and node.attrs.level or 1
        local prefix = string.rep("#", level) .. " "
        local inner = ""
        if node.content then
            for _, child in ipairs(node.content) do
                inner = inner .. ExtractText(child, context)
            end
        end
        return prefix .. inner .. "\n\n"
    end

    if node.type == "bulletList" or node.type == "orderedList" then
        local items = ""
        local idx = 1
        if node.content then
            for _, child in ipairs(node.content) do
                local item_ctx = {
                    list_type = node.type,
                    list_index = idx,
                    indent = (context.indent or 0),
                }
                items = items .. ExtractText(child, item_ctx)
                idx = idx + 1
            end
        end
        if not context.list_type then
            items = items .. "\n"
        end
        return items
    end

    if node.type == "listItem" then
        local indent = string.rep("  ", context.indent or 0)
        local bullet
        if context.list_type == "orderedList" then
            bullet = context.list_index .. ". "
        else
            bullet = "- "
        end
        local inner = ""
        if node.content then
            for i, child in ipairs(node.content) do
                if child.type == "paragraph" then
                    local text = ""
                    if child.content then
                        for _, c in ipairs(child.content) do
                            text = text .. ExtractText(c, context)
                        end
                    end
                    if i == 1 then
                        inner = inner .. text
                    else
                        inner = inner .. "\n" .. indent .. "  " .. text
                    end
                else
                    local nested_ctx = { indent = (context.indent or 0) + 1 }
                    inner = inner .. "\n" .. ExtractText(child, nested_ctx)
                end
            end
        end
        return indent .. bullet .. inner .. "\n"
    end

    if node.type == "paragraph" then
        local inner = ""
        if node.content then
            for _, child in ipairs(node.content) do
                inner = inner .. ExtractText(child, context)
            end
        end
        if context.list_type then
            return inner
        end
        return inner .. "\n\n"
    end

    if node.content then
        for _, child in ipairs(node.content) do
            result = result .. ExtractText(child, context)
        end
    end

    return result
end


local function JiraSearch(q)
    local opts = {}

    local jql
    local project = M._config.default_project
    if q == "" then
        jql = 'project = "' .. project .. '" AND sprint in openSprints()'
    elseif tonumber(q) then
        jql = "id = " .. project .. "-" .. q
    elseif q:match("^%a+%-%d+$") then
        project = q:match("^(%a+)%-")
        jql = "id = " .. q
    elseif q:match("^%a+$") then
        project = q:upper()
        jql = 'project = "' .. project .. '" AND sprint in openSprints()'
    else
        jql = "summary ~ \"" .. escape_string(q) .. "\""
    end
    local results = M.search(jql, { project = project }).items

    local function insert_issue_link(key, summary)
        local text = "[" .. summary .. "](" .. M._config.base_url .. "/browse/" .. key .. ")"
        local bufnr = vim.fn.bufnr()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local row = cursor_pos[1] - 1
        local col = cursor_pos[2]
        vim.api.nvim_buf_set_text(bufnr, row, col, row, col, { text })
    end

    if #results == 1 then
        insert_issue_link(results[1].key, results[1].summary)
        return
    end

    pickers.new(opts, {
        prompt_title = "Search Jira Issues",

        finder = finders.new_table {
            results = results,
            entry_maker = function(entry)
                return {
                    value = entry.id,
                    display = entry.key .. "  " .. entry.summary,
                    ordinal = entry.key .. " " .. entry.summary,
                    description = entry.description,
                    key = entry.key,
                    summary = entry.summary,
                }
            end
        },

        sorter = conf.generic_sorter(opts),

        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                insert_issue_link(selection.key, selection.summary)
            end)
            return true
        end,

        previewer = previewers.new_buffer_previewer {
            title = "Jira Issue",
            filetype = 'markdown',
            define_preview = function(self, entry, status)
                local lines = {
                    "# " .. entry.key,
                    "",
                    entry.summary,
                    "",
                    "---",
                    "",
                }
                if entry.description and entry.description ~= "" then
                    for line in string.gmatch(entry.description .. "\n", "(.-)\n") do
                        table.insert(lines, line)
                    end
                else
                    table.insert(lines, "*No description*")
                end
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                vim.treesitter.start(self.state.bufnr, "markdown")
                vim.api.nvim_set_option_value("conceallevel", 2, { win = self.state.winid })
                vim.api.nvim_set_option_value("concealcursor", "nvic", { win = self.state.winid })
            end
        }
    }):find()
end

local function get_my_account_id()
    local res = make_request("get", "myself")
    if res.status == 200 and res.data then
        return res.data.accountId
    end
    return nil
end

-- Net status transition I made on `key` today, e.g. "To Do → In Progress".
-- Returns nil if I made no status changes today.
local function todays_status_transition(key, account_id, today)
    local res = make_request("get", "issue/" .. key .. "/changelog", {
        query = { maxResults = 100 }
    })
    if res.status ~= 200 or not res.data or not res.data.values then
        return nil
    end

    -- created timestamps share the account timezone offset, so sort lexically.
    table.sort(res.data.values, function(a, b) return a.created < b.created end)

    local from_status, to_status
    for _, entry in ipairs(res.data.values) do
        if entry.created:sub(1, 10) == today
            and entry.author and entry.author.accountId == account_id then
            for _, item in ipairs(entry.items or {}) do
                if item.field == "status" then
                    from_status = from_status or item.fromString
                    to_status = item.toString
                end
            end
        end
    end

    if from_status and to_status then
        return from_status .. " → " .. to_status
    end
    return nil
end

-- offset is a day offset: 0 = today, -1 = yesterday, etc.
local function JiraWorkedOn(offset)
    offset = offset or 0
    local day_arg = offset == 0 and "" or tostring(offset)
    local jql = string.format(
        "assignee = currentUser() AND updated >= startOfDay(%s) AND updated <= endOfDay(%s) ORDER BY updated DESC",
        day_arg, day_arg)
    local results = M.search(jql, { maxResults = 50 }).items

    local target = os.date("*t")
    target.day = target.day + offset
    local target_date = os.date("%Y-%m-%d", os.time(target))

    if #results == 0 then
        vim.notify("No Jira tickets worked on " .. target_date, vim.log.levels.INFO)
        return
    end

    local account_id = get_my_account_id()

    local lines = {}
    for _, issue in ipairs(results) do
        local link = string.format("[%s](%s)", issue.summary, M.get_browse_url(issue.key))
        local transition = account_id and todays_status_transition(issue.key, account_id, target_date)
        if transition then
            table.insert(lines, string.format("- [X] WORK ON: %s (%s)", link, transition))
        else
            table.insert(lines, string.format("- [X] WORK ON: %s", link))
        end
    end

    local file_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local header = "## " .. target_date
    local insert_at = nil

    -- Find exact match or closest past date header
    local best_line = nil
    for i, line in ipairs(file_lines) do
        local date = line:match("^## (%d%d%d%d%-%d%d%-%d%d)$")
        if date then
            if date == target_date then
                insert_at = i
                break
            elseif date < target_date and (not best_line or date > file_lines[best_line]:match("^## (%d%d%d%d%-%d%d%-%d%d)$")) then
                best_line = i
            end
        end
    end

    if not insert_at then
        if best_line then
            -- Insert the target header before the closest past date header
            table.insert(file_lines, best_line, "")
            table.insert(file_lines, best_line, header)
            insert_at = best_line
        else
            -- No date headers found, append at end
            table.insert(file_lines, "")
            table.insert(file_lines, header)
            insert_at = #file_lines
        end
    end

    for j, work_line in ipairs(lines) do
        table.insert(file_lines, insert_at + j, work_line)
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, file_lines)
    vim.notify(string.format("Added %d Jira tickets worked on %s", #lines, target_date), vim.log.levels.INFO)
end

M.setup = function(config)
    config = config or {}
    M._config = vim.tbl_deep_extend("force", {
        base_url = os.getenv("JIRA_SERVER") or "",
        username = os.getenv("JIRA_USERNAME") or "",
        token = os.getenv("JIRA_API_TOKEN") or "",
        default_project = os.getenv("JIRA_DEFAULT_PROJECT") or "",
    }, config)
    if M._config.username == "" or M._config.token == "" then
        -- Only warn if not provided, checking against empty string since logic above uses empty string default
        -- print("Username:" .. M._config.username .. " is not set or n JIRA_API_TOKEN")
    end

    vim.api.nvim_create_user_command('JiraSearch', function(opts)
        local args = opts.fargs[1] or ""
        JiraSearch(args)
    end, { nargs = '*' })

    vim.api.nvim_create_user_command('JiraWorkedOn', function(opts)
        local offset = tonumber(opts.fargs[1]) or 0
        JiraWorkedOn(offset)
    end, { nargs = '?', desc = "Insert worked-on Jira tickets under the date heading (arg: day offset, e.g. -1 for yesterday)" })
end

return M
