local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- colorscheme
    { "navarasu/onedark.nvim", lazy = false },
    { "rmehri01/onenord.nvim", lazy = false },

    "nathom/filetype.nvim",

    { "lewis6991/impatient.nvim", lazy = false },

    "folke/neodev.nvim",

    -- telescope
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = false, priority = 1000 },
    { "nvim-telescope/telescope.nvim",
        version = "0.1.0",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        lazy = false,
    },

    {"nvim-treesitter/nvim-treesitter", build = ':TSUpdate', lazy = false },
    {"nvim-treesitter/nvim-treesitter-textobjects", lazy = false },
    {"nvim-treesitter/nvim-treesitter-context", lazy = false },
    {"JoosepAlviste/nvim-ts-context-commentstring", lazy = false },

    -- workflow
    "theprimeagen/harpoon",
    "mbbill/undotree",

    -- git plugins
    "lewis6991/gitsigns.nvim",
    "tpope/vim-fugitive",
    "shumphrey/fugitive-gitlab.vim",

    { "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            {'neovim/nvim-lspconfig'},
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            -- Snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',

            --menu formatting
            'onsails/lspkind.nvim',
        }
    },

    "folke/zen-mode.nvim",

    --use("github/copilot.vim")

    "tpope/vim-unimpaired",
    "tpope/vim-surround", --easier to change surrounding characters
    "tpope/vim-repeat", -- repeating plugin mappings

    -- linting and formatting
    "jose-elias-alvarez/null-ls.nvim",
    "jay-babu/mason-null-ls.nvim",

    -- better status line
    "nvim-lualine/lualine.nvim", -- Fancier statusline

    -- testing 
    'vim-test/vim-test',

    -- debuggin
    { 'mfussenegger/nvim-dap' },
    { 'rcarriga/nvim-dap-ui' },
    -- use { 'Pocco81/dap-buddy.nvim' }
    { 'theHamsta/nvim-dap-virtual-text' },

    -- commet out stuff with gc
    { "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup({
                pre_hook = function()
                    require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
                end,
            })
        end
    };

    -- note taking
    -- "renerocksai/telekasten.nvim",
    {
        'jakewvincent/mkdnflow.nvim',
        opts = {
            rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
        },
        config = function()
            require('mkdnflow').setup({
                mappings = {
                    MkdnEnter = {{'i', 'n', 'v'}, '<CR>'} -- This monolithic command has the aforementioned
                    -- insert-mode-specific behavior and also will trigger row jumping in tables. Outside
                    -- of lists and tables, it behaves as <CR> normally does.
                    -- MkdnNewListItem = {'i', '<CR>'} -- Use this command instead if you only want <CR> in
                    -- insert mode to add a new list item (and behave as usual outside of lists).
                },
                new_file_template = {
                    use_template = true,
                    placeholders = {
                        before = {
                            title = "link_title",
                            date = "os_date"
                        },
                        after = {}
                    },
                    template = [[--- 
title: {{ title }} 
date: {{ date }}
participants: 
documentation: 
  
---
  
# 
]]
                },
            })
        end
    },

    -- better lsp for rust
    "simrat39/rust-tools.nvim",

    -- toggle term
    { "akinsho/toggleterm.nvim",
        version = '*',
        config = function()
            require("toggleterm").setup()
        end
    },

    { "phpactor/phpactor",
        build = "composer install --no-dev -o",
    },

    -- lsp Autocompletion for json and yaml files
    {'b0o/schemastore.nvim'},
})
