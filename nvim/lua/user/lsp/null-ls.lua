local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		formatting.stylua,
        formatting.phpcsfixer,
        diagnostics.php,
        diagnostics.phpcs.with({ extra_args = { "--standard=~/.config/phpcs/laravelstandards.xml"}}),
        -- null_ls.builtins.code_actions.gitsigns,
    -- diagnostics.flake8
	},
})
