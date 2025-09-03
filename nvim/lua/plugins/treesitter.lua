return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        branch = 'main',
		dependencies = {"nvim-treesitter/nvim-treesitter-context"},
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
        config = function()
            local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim',
                'vimdoc', 'php' }
            require('nvim-treesitter').install(parsers)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = parsers,
                callback = function()
                    -- enbales syntax highlighting and other treesitter features
                    vim.treesitter.start()

                    -- enbales treesitter based folds
                    -- for more info on folds see `:help folds`
                    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

                    -- enables treesitter based indentation
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    }
}
