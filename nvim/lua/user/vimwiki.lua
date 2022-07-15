-- local cmp_status_ok, cmp = pcall(require, "vimwiki")
-- if not cmp_status_ok then
--     return
-- end

vim.cmd [[
    let g:vimwiki_list = [{'path': '~/socialblue/notes/vimwiki/'}]

    hi VimwikiHeader1 guifg=#89DDFF
    hi VimwikiHeader2 guifg=#c792ea
    hi VimwikiHeader3 guifg=#939ede
    hi VimwikiHeader4 guifg=#82b1ff
    hi VimwikiHeader5 guifg=#ff869a
    hi VimwikiHeader6 guifg=#ff5370

    let g:vimwiki_list = [{'path': '~/socialblue/notes/vimwiki/',
    \ 'syntax': 'markdown', 'ext': '.md'}]

    "let g:vimwiki_folding='syntax'

]]
