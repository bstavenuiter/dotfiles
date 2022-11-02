local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  -- snapshot = "snapshot",
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use "wbthomason/packer.nvim" -- Have packer manage itself

    -- use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
    use "numToStr/Comment.nvim" -- Easily comment stuff
    -- use { "kyazdani42/nvim-tree.lua",
    --     requires = {
    --         'kyazdani42/nvim-web-devicons', -- optional, for file icon
    --     },
    -- }
    -- use "akinsho/bufferline.nvim"
    use "moll/vim-bbye"
    use "qpkorr/vim-bufkill"
    use "nvim-lualine/lualine.nvim" -- status bar
    use "tpope/vim-unimpaired"
    use "tpope/vim-surround" --easier to change surrounding characters
    use 'tpope/vim-repeat' -- repeating plugin mappings
    use 'machakann/vim-highlightedyank' -- highlight your yankin

    use "akinsho/toggleterm.nvim"
    -- use "ahmedkhalf/project.nvim"
    use "lewis6991/impatient.nvim"  -- faster neovim
    use "lukas-reineke/indent-blankline.nvim" -- line showing how much has been indented
    use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight

    -- Colorschemes
    -- use "sainnhe/edge"
    --use 'marko-cerovac/material.nvim'
    -- use 'rmehri01/onenord.nvim'
    use "folke/tokyonight.nvim"
    use 'navarasu/onedark.nvim'
    use 'gruvbox-community/gruvbox'
    use { "catppuccin/nvim", as = "catppuccin" }

    -- cmp plugins
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"
    --[[ use "RRethy/vim-illuminate" --highlight current word ]]

    --linters
    use 'mfussenegger/nvim-lint' --not using this because we use ecs, which isnt' supported out of the box
    --[[ use 'dense-analysis/ale' ]]

    -- snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
    -- use "neovim/nvim-lspconfig" -- enable LSP
    -- use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    use { 'VonHeikemen/lsp-zero.nvim' }
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
        "jayp0521/mason-null-ls.nvim",
    }
    use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for

    -- Telescope
    use "nvim-telescope/telescope.nvim"
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- use fzf, for speed reasons

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/nvim-treesitter-context' -- shows the current function you are on at the top
    use "JoosepAlviste/nvim-ts-context-commentstring"

    -- Git
    use "lewis6991/gitsigns.nvim"
    use "tpope/vim-fugitive"
    use 'shumphrey/fugitive-gitlab.vim'

    -- Highlight search stops when you move
    use "romainl/vim-cool"

    -- Undo tree
    use 'mbbill/undotree'

    -- note taking
    --use "vimwiki/vimwiki"
    --[[ use "ellisonleao/glow.nvim" ]]
    use { 'renerocksai/telekasten.nvim' }

    -- side ways move function parameters left and right alt-h and alt-j
    --[[ use "AndrewRadev/sideways.vim" ]]

    -- testing
    use "vim-test/vim-test"

    -- tracking which project and files you are in
    use "wakatime/vim-wakatime"

    -- Refactoring Tools
    --[[ use {'phpactor/phpactor', ft = {'php'}, run = 'composer install'} ]]

    -- codi used for psysh inside the term, just like tinkerwell
    --[[ use { 'metakirby5/codi.vim' } ]]

    -- easier navigation between tmux and vim
    use { 'christoomey/vim-tmux-navigator' }
    -- the primeagen file navigation
    use { 'ThePrimeagen/harpoon' }

    -- dap debugger
    use { 'mfussenegger/nvim-dap' }
    use { 'rcarriga/nvim-dap-ui' }
    -- use { 'Pocco81/dap-buddy.nvim' }
    use { 'theHamsta/nvim-dap-virtual-text' }

    --[[ use { 'kdheepak/lazygit.nvim' } ]]

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)

