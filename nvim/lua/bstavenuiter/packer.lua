-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)

    -- alternative to the native filetype.vim, this one is quite faster
    use("nathom/filetype.nvim")

    -- better startuptime
    use("lewis6991/impatient.nvim")

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'folke/neodev.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- use fzf, for speed reasons

    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('nvim-treesitter/nvim-treesitter-context') -- shows the current function you are on at the top
    use("JoosepAlviste/nvim-ts-context-commentstring")

    --use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')
    use('mbbill/undotree')

    -- git plugins
    use("lewis6991/gitsigns.nvim")
    use("tpope/vim-fugitive")
    use("shumphrey/fugitive-gitlab.vim")

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use("folke/zen-mode.nvim")

    --use("github/copilot.vim")

    -- colorscheme
    use("navarasu/onedark.nvim")

    use("tpope/vim-unimpaired")
    use("tpope/vim-surround") --easier to change surrounding characters
    use("tpope/vim-repeat") -- repeating plugin mappings

    -- linting and formatting
    use("jose-elias-alvarez/null-ls.nvim")

    -- better status line
    use("nvim-lualine/lualine.nvim") -- Fancier statusline

    -- testing 
    use( 'vim-test/vim-test' )

    -- debuggin
    use { 'mfussenegger/nvim-dap' }
    use { 'rcarriga/nvim-dap-ui' }
    -- use { 'Pocco81/dap-buddy.nvim' }
    use { 'theHamsta/nvim-dap-virtual-text' }

    -- commet out stuff with gc
    use {"numToStr/Comment.nvim", config = function()
        require('Comment').setup({
            pre_hook = function()
                require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            end,
        })
    end};

    -- note taking
    use("renerocksai/telekasten.nvim")

    -- better lsp for rust
    use("simrat39/rust-tools.nvim")

    -- toggle term
    use {"akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end}
end)

