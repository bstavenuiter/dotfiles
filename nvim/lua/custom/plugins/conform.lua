return {
	"stevearc/conform.nvim",

	keys = {
		{
			"<leader>fo",
			function()
				require("conform").format({
					async = true,
					timeout_ms = 5000,
					lsp_format = "fallback",
					lsp_fallback = true,
				})
			end,
			desc = "Formats via conform fallback on lsp",
			mode = "",
		},
	},

	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local ignore_filetypes = { "php" }
			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				return
			end
			return { timeout_ms = 5000, lsp_fallback = true, async = false }
		end,

		formatters_by_ft = {
			lua = { "stylua" },
			php = { "ecs" },
		},
	},

	init = function()
		require("conform").formatters.ecs = function(bufnr)
			local util = require("conform.util")

			local command = util.find_executable({
				"vendor/bin/ecs",
			}, "ecs")

			local config_file = vim.fs.find(
				"easy-coding-standard.php",
				{ path = vim.loop.cwd() .. "/vendor/socialblue/php-code-style/" }
			)[1]

			if command == nil then
				command = util.find_executable({
					"$HOME/code/php-code-style/vendor/bin/ecs",
				}, "ecs")
			end

			if config_file == nil then
				config_file = "$HOME/code/php-code-style/easy-coding-standard.php"
			end

			return {
				command = command,
				args = { "check", "$FILENAME", "--fix", "--config", config_file, "-n", "-q" },
				cwd = util.root_file({
					"vendor/bin/ecs",
				}),
				stdin = false,
			}
		end
	end,
}
