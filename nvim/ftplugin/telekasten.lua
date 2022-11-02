local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<C-Space>", "<cmd>Telekasten toggle_todo<cr>", opts)
