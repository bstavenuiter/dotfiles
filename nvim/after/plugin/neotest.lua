local plugin_status_ok, neotest = pcall(require, "neotest")
if not plugin_status_ok then
    return
end

local opts = { noremap = true, silent = true }

neotest.setup({
    adapters = {
        require("neotest-phpunit"),
        -- require("neotest-pest")
    },
})

vim.api.nvim_set_keymap('n', '<leader>tt', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', opts) -- test file
vim.api.nvim_set_keymap('n', '<leader>tn', ':lua require("neotest").run.run()<CR>', opts) -- test nearest
vim.api.nvim_set_keymap('n', '<leader>ts', ':lua require("neotest").summary.toggle()<CR>', opts) -- toggle the summary
vim.api.nvim_set_keymap('n', '<leader>to', ':lua require("neotest").output_panel.toggle()<CR>', opts) --open the output panel
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua require("dap").toggle_breakpoint()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua require("dapui").toggle()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua require("dapui").float_element()<CR>', opts)
