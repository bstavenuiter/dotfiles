return {
	"folke/trouble.nvim",

	dependencies = { "nvim-tree/nvim-web-devicons" },

	opts = {},

	win = {
		type = "float",
	},

	keys = {
		{
			"<leader>dg",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Global Diagnostics (Trouble)",
		},
		{
			"<leader>do",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
	},
}
