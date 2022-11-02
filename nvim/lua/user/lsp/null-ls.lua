local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local phpcbfixer = {
    method = null_ls.methods.CODE_ACTION,
    filetypes = {"php"},
    generator = {
        fn = function(_)
            local actions = {}
            table.insert(actions, {
                title = "Run phpcbf",
                action = function()
                    vim.api.nvim_buf_call(params.bufnr, action)
                end,
            })
            return actions
        end,
    }
}

null_ls.setup({
	debug = false,
    diagnostics_format = "#{m} (#{c}) [#{s}]",    -- Makes PHPCS errors more readeable
	sources = {
		formatting.stylua,
        --[[ formatting.phpcsfixer, ]]
        formatting.phpcbf.with({ 
            prefer_local = "vendor/bin",
            extra_args = { "--standard=~/.config/phpcs/laravelstandards.xml"}
        }),
        formatting.phpcsfixer,
        diagnostics.php,
        diagnostics.phpcs.with({ 
            prefer_local = "vendor/bin",
            extra_args = { "--standard=~/.config/phpcs/laravelstandards.xml"}
        }),
        --[[ diagnostics.phpcs, ]]
        diagnostics.phpstan.with({
            extra_args = { "--level=5"}
        }),
        -- null_ls.builtins.code_actions.gitsigns,
    -- diagnostics.flake8
	},
})

null_ls.register(phpcbfixer)
