local options = {

    nu = true,
    relativenumber = true,

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    smartindent = true,
    autoindent = true,

    swapfile = false,
    backup = false,
    undodir = os.getenv("HOME") .. "/.vim/undodir",
    undofile = true,

    hlsearch = false,
    incsearch = true,

    termguicolors = true,

    scrolloff = 8,
    sidescrolloff = 8,
    signcolumn = "yes",

    updatetime = 50,

    splitbelow = true,
    splitright = true,
    winbar = [[%#Question#%t%m]],

    -- search ignores casing,
    ignorecase = true,
    -- but when capitalizing anything will trigger sensitive search
    smartcase = true,
    completeopt = "menu,menuone"
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
