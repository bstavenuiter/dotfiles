-- local status_ok, comment = pcall(require, "fugitive")
-- if not status_ok then
--     return
-- end

-- issue when calling GBrowse because of nvim-tree https://githubplus.com/kyazdani42/nvim-tree.lua/issues/559
vim.cmd [[
    command -nargs=1 Browse silent exe '!open ' . "<args>" 
    autocmd BufReadPost fugitive://* set bufhidden=delete
    let g:fugitive_gitlab_domains = ['https://gitlab.socialblue.com']
]]
