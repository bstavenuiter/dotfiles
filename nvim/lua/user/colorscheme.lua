local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
    return
end

-- onedark
onedark.load()
onedark.setup {
    toggle_style_list = {'light', 'warm'},
    style = 'warm',
    toggle_style_key = '<leader>rr'
}

vim.cmd [[colorscheme onedark]]

local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
    return
end

vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha

require("catppuccin").setup({
    integrations = {
        cmp = true,
        gitsigns = true,
        markdown = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        treesitter_context = false,
	},
    compile = {
        enabled = true,
        path = vim.fn.stdpath "cache" .. "/catppuccin"
    }
})

