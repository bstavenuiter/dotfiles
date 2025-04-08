return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.keymap.set("n", "<leader>nr", ":Neotree reveal_file=./%:p position=right<CR>")
			vim.keymap.set("n", "<leader>nn", ":Neotree filesystem toggle right<CR>")
		end,
	}
}
