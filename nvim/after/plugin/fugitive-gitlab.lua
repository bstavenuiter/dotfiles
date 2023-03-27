vim.cmd([[
    command -nargs=1 Browse silent exe '!open ' . "<args>" 
    autocmd BufReadPost fugitive://* set bufhidden=delete
    let g:fugitive_gitlab_domains = ['https://gitlab.socialblue.com']
]])
