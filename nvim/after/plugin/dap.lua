local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/Users/b.stavenuiter/code/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug (9003)',
    port = 9003
  }
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dapui.setup()

require("nvim-dap-virtual-text").setup()
vim.g.dap_virtual_text = true

-- mapping
--
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>dn', ':lua require("dap").step_over()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>di', ':lua require("dap").step_into()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require("dap").step_out()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require("dap").continue()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require("dap").toggle_breakpoint()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>du', ':lua require("dapui").toggle()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>df', ':lua require("dapui").float_element()<CR>', opts)

