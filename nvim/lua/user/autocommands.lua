vim.cmd [[
    "---------- Jump back to last edited position ----------
    augroup lasteditedposition
        autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
    augroup end

    "---------- don't wrap lines in markdown or wiki filetypes ---
    augroup notes
        autocmd!
        autocmd FileType markdown set nowrap
        autocmd FileType vimwiki set nowrap
        autocmd FileType vimwiki set list
        autocmd FileType markdown set list
    augroup end
]]
