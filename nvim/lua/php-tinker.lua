local M = {}

local tinker_bufnr = nil
local tinker_command = 'php artisan tinker'
local split_command = 'botright split'

---Finds an existing tinker terminal or creates a new one.
---@return number|nil, number|nil
local function get_tinker_chan_and_win()
    if tinker_bufnr and vim.api.nvim_buf_is_valid(tinker_bufnr) then
        local target_win_id = vim.fn.bufwinid(tinker_bufnr)
        if target_win_id ~= -1 then
            local chan_id = vim.api.nvim_buf_get_var(tinker_bufnr, 'terminal_job_id')
            if chan_id and chan_id > 0 then
                return chan_id, target_win_id
            end
        end
    end

    -- No suitable terminal found, or it has been closed. Let's create one.
    tinker_bufnr = M.create_split()
    local new_chan_id = vim.api.nvim_buf_get_var(tinker_bufnr, 'terminal_job_id')

    if not (new_chan_id and new_chan_id > 0) then
        vim.notify("Failed to start ' .. tinker_command .. ' process.", vim.log.levels.ERROR)
        vim.cmd('close')
        vim.cmd('wincmd p') -- Return focus
        tinker_bufnr = nil
        return nil, nil
    end

    vim.notify("Starting new tinker session...", vim.log.levels.INFO)
    -- Wait a bit for tinker to initialize
    vim.cmd('sleep 200m')
    return new_chan_id, vim.fn.bufwinid(tinker_bufnr)
end

--- Sends the content of the default yank register to the tinker terminal.
function M.send()
    local yanked_text = vim.fn.getreg('"')
    if yanked_text == '' then
        vim.notify("Yank register is empty", vim.log.levels.WARN)
        return
    end

    -- Remove consecutive empty lines
    yanked_text = yanked_text:gsub("\n\n+", "\n")

    local chan_id, win_id = get_tinker_chan_and_win()
    if not (chan_id and win_id) then
        return
    end

    vim.api.nvim_chan_send(chan_id, yanked_text .. "\n")
    vim.notify("Sent yanked text to tinker terminal", vim.log.levels.INFO)

    vim.api.nvim_win_call(win_id, function()
        vim.cmd('stopinsert')
        vim.cmd('normal! G')
        vim.cmd('wincmd p')
    end)
end

--- Sends the entire file content to the tinker terminal.
function M.send_file()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, "\n")

    -- Remove <?php tag
    content = content:gsub("%s*<%?php", "")
    -- Remove block comments
    content = content:gsub("/%*.-%*/", "")
    -- Remove single line comments
    local clean_lines = {}
    for line in content:gmatch("([^ ]*)") do
        if not line:match("^%s*//") and not line:match("^%s*#") then
            table.insert(clean_lines, line)
        end
    end
    content = table.concat(clean_lines, "\n")
    content = content:gsub("\n\n+", "\n")

    if content == '' then
        vim.notify("No content to send after filtering.", vim.log.levels.WARN)
        return
    end

    local chan_id, win_id = get_tinker_chan_and_win()
    if not (chan_id and win_id) then
        return
    end

    vim.api.nvim_chan_send(chan_id, content .. "\n")
    vim.notify("Sent file content to tinker terminal", vim.log.levels.INFO)

    vim.api.nvim_win_call(win_id, function()
        vim.cmd('stopinsert')
        vim.cmd('normal! G')
        vim.cmd('wincmd p')
    end)
end

--- Closes the old tinker session and starts a new one.
function M.renew_tinker_session()
    M.close_split()

    tinker_bufnr = M.create_split()
    vim.notify("Tinker session renewed.", vim.log.levels.INFO)
end

function M.close_split()
    if tinker_bufnr and vim.api.nvim_buf_is_valid(tinker_bufnr) then
        local target_win_id = vim.fn.bufwinid(tinker_bufnr)
        if target_win_id ~= -1 then
            vim.api.nvim_win_close(target_win_id, true)
        end
    end
end

function M.create_split()
    vim.cmd(split_command)
    local success, _ = pcall(vim.cmd, 'terminal ' .. tinker_command)

    if not success then
        vim.notify("Failed to run terminal command!", vim.log.levels.ERROR)
        return nil, nil
    end

    tinker_bufnr = vim.api.nvim_get_current_buf()
    vim.cmd('normal! G')
    vim.cmd('wincmd p')
    return tinker_bufnr
end
return M
