local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("x", "<C-j>", ":m '>+1<cr>gv=gv", opts)
keymap("x", "<C-k>", ":m '<-2<cr>gv=gv", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "∆", ":m .+1<CR>==", opts)
keymap("v", "˚", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "∆", ":move '>+1<CR>gv-gv", opts)
keymap("x", "˚", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Save write
-- quick key to write file
keymap("n", "<leader>w", ":w<cr>", opts)

-- Telescope --
-- telescope find functions trough ripgrep
keymap('n', '<leader>g', ':Telescope live_grep find_command=rg,--ignore,--hidden,--files<CR>', opts)
keymap('n', '<leader>t', ':Telescope find_files find_command=rg,--ignore,--files<CR>', opts)
keymap('n', '<leader>b', ':Telescope buffers find_command=rg,--ignore,--hidden,--files<CR>', opts)
keymap('n', '<leader>gc', ':Telescope git_commits find_command=rg,--ignore,--hidden,--files<CR>', opts)
keymap('n', '<leader>gb', ':Telescope git_branches find_command=rg,--ignore,--hidden,--files<CR>', opts)
keymap('n', '<leader>gf', ':Telescope git_files find_command=rg,--ignore,--hidden,--files<CR>', opts)
keymap('n', '<leader><leader>', ':Telescope git_files find_command=rg,--ignore,--hidden,--files<CR>', opts)
keymap('n', '<leader>ls', ":lua require'telescope.builtin'.treesitter{default_text=':method:'}<CR>", opts)

-- quickly delete current buffer, needs buffkill
keymap('n', '<leader>q', ':BD<cr>', opts)

-- quickly edit this file
keymap('n', '<leader>em', ':e ~/.config/nvim/lua/user/keymaps.lua<cr>', opts)
keymap('n', '<leader>ep', ':e ~/.config/nvim/lua/user/plugins.lua<cr>', opts)
keymap('n', '<leader>ei', ':e ~/.config/nvim/init.lua<cr>', opts)
keymap('n', '<leader>eo', ':e ~/.config/nvim/lua/user/options.lua<cr>', opts)
keymap('n', '<leader>es', ':e ~/.config/nvim/lua/user/luasnip.lua<cr>', opts)

-- fugitive
keymap('n', '<leader>ge', ':Ge:<CR>', opts)

--nvim-tree
keymap('n', '<leader>f', ':NvimTreeToggle<CR>', opts)
keymap('n', '<leader>fn', ':NvimTreeFindFile<CR>', opts)

-- quickly create a diff
keymap('n', '<leader>dt', ':windo diffthis<CR>', opts)
keymap('n', '<leader>do', ':windo diffoff<CR>', opts)

-- formatting a json file
keymap('n', '<leader>lj', "<cmd>%!jq<CR>", opts)
keymap('n', '<leader>lx', "<cmd>%!xmllint --format --recover -<CR>", opts)

-- trigger completion menu via ctrl-n
keymap('i', '<C-n>', "<cmd>lua require('cmp').complete()<CR>", opts)

-- yank entire file
keymap('n', '<leader>y', ':%y+<cr>', opts)
-- yank selection to clipboard
keymap('v', '<leader>y', '"*y<cr>', opts)
--relative path
keymap('n', '<leader>yr', ':let @* = expand("%")<CR>', opts)
--absolute path
keymap('n', '<leader>ya', ':let @* = expand("%:p")<CR>', opts)
-- filename
keymap('n', '<leader>yf', ':let @* = expand("%:t")<CR>', opts)
-- directory name
keymap('n', '<leader>yd', ':let @* = expand("%:p:h")<CR>', opts)

--copy current md file to rtf in clipboard
keymap('n', '<leader>yp', ':silent exec "!pandoc --standalone --from=markdown --to=rtf % | pbcopy"<cr>', opts)

keymap('n', '˙', ':SidewaysLeft<cr>', opts)
keymap('n', '¬', ':SidewaysRight<cr>', opts)

keymap('n', '<leader>si', '<Plug>SidewaysArgumentInsertBefore', {silent = true})
keymap('n', '<leader>sa', '<Plug>SidewaysArgumentAppendAfter', {silent = true})
keymap('n', '<leader>sI', '<Plug>SidewaysArgumentInsertFirst', {silent = true})
keymap('n', '<leader>sA', '<Plug>SidewaysArgumentAppendLast', {silent = true})

-- formatting via null-ls
keymap('n', '<leader>ff', ':lua vim.lsp.buf.formatting()<cr>', opts)
keymap('v', '<leader>ff', ':lua vim.lsp.buf.range_formatting()<cr>', opts)

-- vim dap testing
keymap('n', '<leader>tn', ':TestNearest --no-coverage<cr>', opts)
keymap('n', '<leader>tf', ':TestFile --no-coverage<cr>', opts)
keymap('n', '<leader>tl', ':TestLast --no-coverage<cr>', opts)

-- close the quickfix window
keymap('n', '<leader>cq', ':cclose<cr>', opts)

keymap('n', '<leader>ci', ':Codi php<cr>', opts)
keymap('n', '<leader>ll', ':!php vendor/bin/ecs check --fix --config=vendor/socialblue/php-code-style/easy-coding-standard.php --match-git-diff --quiet<cr>', opts)
keymap('n', '<leader>lj', ':!./node_modules/.bin/eslint -c ./node_modules/js-code-style/.eslintrc.json --fix %<cr>', opts)

-- jump to end of line and insert trailing char
keymap('i', ';;', '<ESC>:norm A;<CR>', opts)
keymap('i', ',,', '<ESC>:norm A,<CR>', opts)

-- dap config
keymap('n', '<leader>du', ':lua require("dapui").toggle()<cr>', opts)
keymap('n', '<leader>db', ":lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap('n', '<leader>dc', ":lua require'dap'.continue()<cr>", opts)
keymap('n', '<leader>dn', ":lua require'dap'.step_over()<cr>", opts)
keymap('n', '<leader>di', ":lua require'dap'.step_into()<cr>", opts)
keymap('n', '<leader>dr', ":lua require'dap'.step_out()<cr>", opts)
keymap('n', '<leader>cb', ":lua require'dap'.clear_breakpoints()<cr>", opts)

--
keymap("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>ph", "<cmd>lua _PHP_TOGGLE()<CR>", opts)
keymap("n", "<leader>ti", "<cmd>lua _TINKER_TOGGLE()<CR>", opts)
keymap("n", "<leader>tt", "<cmd>lua _TERM_TOGGLE()<CR>", opts)
