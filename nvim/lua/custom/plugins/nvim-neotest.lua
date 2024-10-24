return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"olimorris/neotest-phpunit",
		"theutz/neotest-pest",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
	},

	config = function()
		local neotest = require("neotest")
		neotest.setup({
			adapters = {
				require("neotest-phpunit"),
			},
			output_panel = {
				enabled = true,
				open = "botright vsplit | vertical resize 50 | normal =",
			},
		})

		vim.keymap.set("n", "<leader>tl", ':lua require("neotest").run.run_last()<CR>', { desc = "Run latest" })
		vim.keymap.set("n", "<leader>tf", ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>')
		vim.keymap.set("n", "<leader>tn", ':lua require("neotest").run.run()<CR>', { desc = "Run nearest test" })
		vim.keymap.set(
			"n",
			"<leader>ts",
			':lua require("neotest").summary.toggle()<CR>',
			{ desc = "Toggle the summary" }
		)
		vim.keymap.set(
			"n",
			"<leader>to",
			':lua require("neotest").output_panel.toggle()<CR>',
			{ desc = "Open the output panel" }
		)
		vim.keymap.set(
			"n",
			"<leader>te",
			':lua require("neotest").output.open({ enter = true })<CR>',
			{ desc = "Open the output panel" }
		)
		vim.keymap.set(
			"n",
			"<leader>td",
			':require("neotest").run.run({strategy = "dap"})<CR>',
			{ desc = "Test nearest with debug" }
		)
	end,
}
