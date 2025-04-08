return {
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		lazy = false, --
		config = function()
			vim.cmd("colorscheme onedark")
		end,
	}

