local opts = { noremap = true, silent = true }
-- Telescope --
-- telescope find functions trough ripgrep
vim.api.nvim_set_keymap('n', '<leader>tn', ':TestNearest<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tf', ':TestFile<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ts', ':TestSuite<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tl', ':TestLast<CR>', opts)
--vim.api.nvim_set_keymap('n', '<leader>g' ':TestVisit<CR>', opts)

vim.cmd([[
let test#strategy = 'harpoon'
let test#neovim#term_position = "vert"
]])
