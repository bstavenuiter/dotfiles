local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save write
-- quick key to write file
keymap("n", "<leader>w", ":w<cr>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts) keymap("n", "<C-l>", "<C-w>l", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- quickly delete current buffer, needs buffkill
keymap('n', '<leader>q', ':bd!<cr>', opts)

-- Move text up and down
keymap("x", "<C-j>", ":m '>+1<cr>gv=gv", opts)
keymap("x", "<C-k>", ":m '<-2<cr>gv=gv", opts)

-- quickly create a diff
keymap('n', '<leader>dt', ':windo diffthis<CR>', opts)
keymap('n', '<leader>do', ':windo diffoff<CR>', opts)

-- formatting a json file
keymap('n', '<leader>lj', "<cmd>%!jq<CR>", opts)
keymap('n', '<leader>lx', "<cmd>%!xmllint --format --recover -<CR>", opts)
keymap('v', '<leader>lj', "<cmd>'<,'>!jq<CR>", opts)

-- yank entire file
keymap('n', '<leader>y', ':%y+<cr>', opts)
-- yank selection to clipboard
keymap('v', '<leader>y', '"*y', opts)
--relative path
keymap('n', '<leader>yr', ':let @* = expand("%")<CR>', opts)
--absolute path
keymap('n', '<leader>ya', ':let @* = expand("%:p")<CR>', opts)
-- filename
keymap('n', '<leader>yf', ':let @* = expand("%:t")<CR>', opts)
-- directory name
keymap('n', '<leader>yd', ':let @* = expand("%:p:h")<CR>', opts)

-- close the quickfix window
keymap('n', '<leader>cq', ':cclose<cr>', opts)

-- jump to end of line and insert trailing char
keymap('i', ';;', '<ESC>:norm A;<CR>', opts)
keymap('i', ',,', '<ESC>:norm A,<CR>', opts)

-- when 'scrolling' center current line
keymap("n", "<C-u>", "<C-u>zz", opts);
keymap("n", "<C-d>", "<C-d>zz", opts);

keymap("n", "<leader>bo", "<cmd>silent !open -a \"Brave Browser\" %<CR>", opts);

-- checkbox todo
-- will add a single - when there isn't any present
-- will add " [ ]" when the line starts with a - but no "[ ]" is present
-- will check the box to "- [X]" when a "- [ ]" is present
-- will uncheck the box to "- [ ]" when a "- [X]" is present
TodoCheck = function()
    local bufnr = vim.api.nvim_get_current_buf();
    local linenr = vim.api.nvim_win_get_cursor(0)[1];
    local curline = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]
    local _, t = string.find(curline, "^%s*-%s%[%s%]")
    local _, s = string.find(curline, "^%s*-%s%[X%]")
    local _, r = string.find(curline, "^%s*-")

    if t ~= nil then
        vim.api.nvim_buf_set_text(bufnr, linenr-1, t-5, linenr-1, t, {"- [X]"})
    elseif s ~= nil then
        vim.api.nvim_buf_set_text(bufnr, linenr-1, s-5, linenr-1, s, {"- [ ]"})
    elseif r ~= nil then
        local new_line = curline:gsub("^(%s*)-(.*)", "%1- [ ]%2")
        vim.api.nvim_buf_set_text(bufnr, linenr-1, 0, linenr-1, curline:len(), { new_line })
    else
        local new_line = curline:gsub("^(%s*)(.*)", "%1- %2")
        vim.api.nvim_buf_set_text(bufnr, linenr-1, 0, linenr-1, curline:len(), { new_line })
    end
end

vim.api.nvim_set_keymap("n", "<C-Space>", "<cmd>lua TodoCheck()<cr>", { noremap = true } );
