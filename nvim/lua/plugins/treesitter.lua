return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',

        init = function()

            require'nvim-treesitter'.install({ 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'php', 'go'})

            vim.api.nvim_create_autocmd('FileType', {
                pattern = require'nvim-treesitter'.get_installed() or {},
                callback = function()
                    -- syntax highlighting, provided by Neovim
                    vim.treesitter.start()
                    -- indentation, provided by nvim-treesitter
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    }
}
