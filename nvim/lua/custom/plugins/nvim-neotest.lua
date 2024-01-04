return {
    'nvim-neotest/neotest',
    dependencies = {
	"nvim-lua/plenary.nvim",
	"olimorris/neotest-phpunit",
	"theutz/neotest-pest",
	"nvim-treesitter/nvim-treesitter",
    },

    config = function()
	local neotest = require("neotest")
	neotest.setup({
	  adapters = {
	    require("neotest-phpunit")
	  }
	})

	vim.keymap.set('n', '<leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>')
	vim.keymap.set('n', '<leader>tn', ':lua require("neotest").run.run()<CR>', { desc = 'Run nearest test'})
	vim.keymap.set('n', '<leader>ts', ':lua require("neotest").summary.toggle()<CR>', { desc = 'Toggle the summary'})
	vim.keymap.set('n', '<leader>to', ':lua require("neotest").output_panel.toggle()<CR>', { desc = 'Open the output panel'})
	vim.keymap.set('n', '<leader>td', ':require("neotest").run.run({strategy = "dap"})<CR>', { desc = 'Test nearest with debug'})

    end
}

