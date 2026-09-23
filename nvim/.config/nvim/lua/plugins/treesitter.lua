return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',

        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            init = function()
                vim.g.no_plugin_maps = true
                -- Or, disable per filetype (add as you like)
                -- vim.g.no_python_maps = true
                -- vim.g.no_ruby_maps = true
                -- vim.g.no_rust_maps = true
                -- vim.g.no_go_maps = true
            end,
            keys = {
                { "am", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end, mode = { "x", "o" }, desc = "Select outer function" },
                { "im", function() require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects") end, mode = { "x", "o" }, desc = "Select inner function" },
            }
        },

        init = function()
            require 'nvim-treesitter'.install({ 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown',
                'markdown_inline', 'query', 'vim', 'vimdoc', 'php', 'go', 'hcl', 'yaml' })

            vim.api.nvim_create_autocmd('FileType', {
                pattern = require 'nvim-treesitter'.get_installed() or {},
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
