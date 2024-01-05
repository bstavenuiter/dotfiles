return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()

	require("copilot").setup({
	    suggestion = { auto_trigger = true },
	})

	vim.keymap.set('i', '<C-]>', function() require("copilot.suggestion").accept() end)
	vim.keymap.set('i', '<C-]>', function() require("copilot.suggestion").accept() end)
    end,


    filetypes = {
	sh = function ()
	    -- disable for .env files
	    if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
		return false
	    end
	    return true
	end,
    },
}
