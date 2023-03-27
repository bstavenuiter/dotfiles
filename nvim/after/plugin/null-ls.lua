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
    filetypes = { "php" },
    generator = {
        fn = function(_)
            local actions = {}
            table.insert(actions, {
                title = "Run phpcbf",
                action = function()
                    vim.api.nvim_buf_call(params.bufnr, actions)
                end,
            })
            return actions
        end,
    }
}

-- local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
-- local event = "BufWritePre" -- or "BufWritePost"
-- local async = event == "BufWritePost"

null_ls.setup({
    debug = true,
    diagnostics_format = "#{m} (#{c}) [#{s}]", -- Makes PHPCS errors more readeable
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>fo", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- -- format on save
            -- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            -- vim.api.nvim_create_autocmd(event, {
            --     buffer = bufnr,
            --     group = group,
            --     callback = function()
            --         vim.lsp.buf.format({ bufnr = bufnr, async = async })
            --     end,
            --     desc = "[lsp] format on save",
            -- })
        end

        if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>fo", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
        end
    end,
    sources = {
        formatting.stylua,
        --[[ formatting.phpcsfixer, ]]
        formatting.phpcbf.with({
            prefer_local = "vendor/bin",
            extra_args = { "--standard=~/.config/phpcs/laravelstandards.xml" }
        }),
        -- formatting.phpcsfixer,
        -- formatting.prettier.with({ extra_filetypes = {"php"}, brace_style = "pre-cs" }),
        -- formatting.prettierd.with({ extra_filetypes = {"php"} }),
        diagnostics.php,
        diagnostics.phpcs.with({
            prefer_local = "vendor/bin",
            extra_args = { "--standard=~/.config/phpcs/laravelstandards.xml" }
        }),
        --[[ diagnostics.phpcs, ]]
        diagnostics.phpstan.with({
            extra_args = { "--level=5" }
        }),
        -- null_ls.builtins.code_actions.gitsigns,
        -- diagnostics.flake8
    },
})

null_ls.register(phpcbfixer)
