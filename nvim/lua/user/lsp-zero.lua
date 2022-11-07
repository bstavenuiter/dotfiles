local status_ok, lsp = pcall(require, "lsp-zero")
if not status_ok then
    return
end

lsp.preset('lsp-compe')
lsp.nvim_workspace()

lsp.set_preferences({
  suggest_lsp_servers = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = true,
  configure_diagnostics = true,
  cmp_capabilities = true,
  manage_nvim_cmp = true,
  call_servers = 'local',
  sign_icons = {
    error = "",
    warn = "",
    hint = "",
    info = "",
  }
})

lsp.on_attach(function(_, bufnr)
  local noremap = {buffer = bufnr, remap = false}
  local bind = vim.keymap.set

  bind('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', noremap)
  bind('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', noremap)
end)

lsp.setup()


vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = false,
  severity_sort = false,
  float = true,
})
