local M = {}

-- Square brackets in the text would break the surrounding markdown link
-- (e.g. an MR title like "[SHR-3277] feat: ..."), so strip them.
local function link(text, url)
    return string.format("[%s](%s)", (text:gsub("[%[%]]", "")), url)
end

-- Build the "(extra) — MR refs" suffix for a todo line.
local function suffix(extra, mrs)
    local out = ""
    if extra and extra ~= "" then
        out = out .. " (" .. extra .. ")"
    end
    if mrs and #mrs > 0 then
        out = out .. " — MR " .. table.concat(mrs, ", ")
    end
    return out
end

-- Combine Jira and GitLab activity for a day offset (0 = today, -1 =
-- yesterday) into WORK ON / REVIEWED todo lines, then insert them under the
-- date heading in the current buffer. Deduped by JIRA key; Jira takes
-- precedence, GitLab MR refs are appended to the matching Jira line.
local function WorkedOn(offset)
    offset = offset or 0

    local ok_j, jira = pcall(require, "jira")
    local ok_g, gitlab = pcall(require, "gitlab")

    local jira_items = ok_j and jira.worked_on(offset) or {}
    local gl_items = ok_g and gitlab.worked_on(offset) or {}
    local target_date = ok_j and jira.offset_date(offset) or os.date("%Y-%m-%d")

    -- WORK ON, keyed by ticket so a Jira ticket and its MRs collapse to one line.
    local work, work_order = {}, {}
    local function work_add(key, entry)
        if not work[key] then
            work[key] = entry
            table.insert(work_order, key)
        end
        return work[key]
    end

    -- Jira first: it has precedence for the line's text and status.
    for _, it in ipairs(jira_items) do
        work_add(it.key, { text = link(it.summary, it.url), extra = it.transition, mrs = {} })
    end

    -- GitLab MRs I authored. Append their ref to an existing Jira line, or start
    -- a new line when Jira didn't surface the ticket.
    for _, it in ipairs(gl_items) do
        if it.category == "work" then
            local key = it.ticket or ("mr:" .. it.ref)
            local existing = work[key]
            if existing then
                table.insert(existing.mrs, it.ref)
            else
                work_add(key, { text = link(it.title, it.url), extra = it.actions, mrs = {} })
            end
        end
    end

    -- REVIEWED: MRs authored by others, excluding anything already under WORK ON.
    local review, review_order = {}, {}
    for _, it in ipairs(gl_items) do
        if it.category == "review" then
            local key = it.ticket or ("mr:" .. it.ref)
            if not work[key] and not review[key] then
                review[key] = { text = link(it.title, it.url), extra = it.actions }
                table.insert(review_order, key)
            end
        end
    end

    local lines = {}
    for _, key in ipairs(work_order) do
        local e = work[key]
        table.insert(lines, "- [X] WORK ON: " .. e.text .. suffix(e.extra, e.mrs))
    end
    for _, key in ipairs(review_order) do
        local e = review[key]
        table.insert(lines, "- [X] REVIEWED: " .. e.text .. suffix(e.extra))
    end

    if #lines == 0 then
        vim.notify("Nothing worked on or reviewed " .. target_date, vim.log.levels.INFO)
        return
    end

    if not (ok_j and jira.insert_worklines) then
        vim.notify("jira.nvim (insert_worklines) is required by workedon", vim.log.levels.ERROR)
        return
    end
    jira.insert_worklines(lines, target_date)
    vim.notify(string.format("Added %d item(s) for %s", #lines, target_date), vim.log.levels.INFO)
end

M.setup = function()
    vim.api.nvim_create_user_command("WorkedOn", function(opts)
        WorkedOn(tonumber(opts.fargs[1]) or 0)
    end, {
        nargs = "?",
        desc = "Insert worked-on + reviewed items (Jira + GitLab) under the date heading (arg: day offset, e.g. -1)",
    })
end

return M
