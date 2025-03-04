return {
	{
		"stevearc/conform.nvim",
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				php = { "easy-coding-standard"},
			},
		}
	}
}
