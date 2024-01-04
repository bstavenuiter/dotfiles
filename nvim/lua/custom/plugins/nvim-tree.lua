return {
    'nvim-tree/nvim-tree.lua',
    config = function ()
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.opt.termguicolors = true
	require("nvim-tree").setup()

	vim.keymap.set("n", "<leader>nn", ':NvimTreeToggle<CR>')
    end
}

