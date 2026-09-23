local M = {}

function M.setup()
    vim.api.nvim_create_user_command("CalendarToday", function()
        local today = os.date("%Y-%m-%d")
        local time_min = today .. "T00:00:00+01:00"
        local time_max = today .. "T23:59:59+01:00"
        local cmd = string.format(
            'gws calendar events list --params \'{"calendarId":"primary","timeMin":"%s","timeMax":"%s","singleEvents":true,"orderBy":"startTime"}\'',
            time_min,
            time_max
        )

        vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            on_stdout = function(_, data)
                local json_str = table.concat(data, "\n")
                local ok, parsed = pcall(vim.json.decode, json_str)
                if not ok or not parsed or not parsed.items then
                    vim.notify("Failed to parse calendar events", vim.log.levels.ERROR)
                    return
                end

                local skip_types = { workingLocation = true, focusTime = true }
                local skip_patterns = { "daily", "breaky", "out of office" }

                local lines = {}
                for _, event in ipairs(parsed.items) do
                    local summary = event.summary or "(no title)"
                    local lower_summary = summary:lower()
                    local skip = skip_types[event.eventType]
                    if not skip then
                        for _, pattern in ipairs(skip_patterns) do
                            if lower_summary:match(pattern) then
                                skip = true
                                break
                            end
                        end
                    end
                    if not skip then
                        local start_time = ""
                        if event.start and event.start.dateTime then
                            start_time = event.start.dateTime:match("T(%d%d:%d%d)") or ""
                        end
                        if start_time ~= "" then
                            table.insert(lines, string.format("- [ ] MEET %s: %s", start_time, summary))
                        else
                            table.insert(lines, string.format("- [ ] MEET: %s", summary))
                        end
                    end
                end

                if #lines == 0 then
                    vim.notify("No events found for today", vim.log.levels.INFO)
                    return
                end

                local file_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                local header = "## " .. today
                local insert_at = nil

                -- Find exact match or closest past date header
                local best_line = nil
                for i, line in ipairs(file_lines) do
                    local date = line:match("^## (%d%d%d%d%-%d%d%-%d%d)$")
                    if date then
                        if date == today then
                            insert_at = i
                            break
                        elseif date < today and (not best_line or date > file_lines[best_line]:match("^## (%d%d%d%d%-%d%d%-%d%d)$")) then
                            best_line = i
                        end
                    end
                end

                if not insert_at then
                    if best_line then
                        -- Insert today's header before the closest past date header
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

                for j, cal_line in ipairs(lines) do
                    table.insert(file_lines, insert_at + j, cal_line)
                end

                vim.api.nvim_buf_set_lines(0, 0, -1, false, file_lines)
                vim.notify(string.format("Added %d calendar events", #lines), vim.log.levels.INFO)
            end,
            on_stderr = function(_, data)
                local err = table.concat(data, "\n")
                if err and err ~= "" then
                    vim.notify("gws error: " .. err, vim.log.levels.ERROR)
                end
            end,
        })
    end, { desc = "Fetch today's calendar events and add to todo.md" })
end

return M
