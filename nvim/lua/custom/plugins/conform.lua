return {
	'stevearc/conform.nvim',
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				php = { 'ecs' },
			},

		})

		require("conform").formatters.ecs = function(bufnr)
			local util = require("conform.util")

			local command = util.find_executable({
				"vendor/bin/ecs",
			}, "ecs")

			local config_file = vim.fs.find("easy-coding-standard.php", { path = vim.loop.cwd() .. "/vendor/socialblue/php-code-style/"})[1]

			print(vim.inspect(command))
			if command == nil then
				print( "$HOME/code/php-code-style/vendor/bin/ecs")
				command = util.find_executable({
					"$HOME/code/php-code-style/vendor/bin/ecs",
				}, "ecs")
			end

			if config_file == nil then
				config_file = "$HOME/code/php-code-style/easy-coding-standard.php"
			end

			print(config_file)
			return {
				command = command,
				args = { "check", "$FILENAME", "--fix", "--config", config_file, '-n', '-q' },
				cwd = util.root_file({
					"vendor/bin/ecs",
				}),
				stdin = false,
			}
		end

		vim.keymap.set('n', '<leader>fo', function() require('conform').format({ timeout_ms = 5000, lsp_fallback = true}) end, { desc = 'Formats via conform fallback on lsp'})
	end
}
