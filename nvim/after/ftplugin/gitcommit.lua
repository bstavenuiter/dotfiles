local branch = vim.fn.system('git branch --show-current')
branch = branch:gsub("^(feature%/)", ''):gsub("^(%a+)-(%d+)(.*)$", '%1-%2')
vim.api.nvim_put({'[' .. branch .. '] '}, 'c', false, true)
