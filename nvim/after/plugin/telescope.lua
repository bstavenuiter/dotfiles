local status_ok, telescope = pcall(require, "telescope")

if not status_ok then
  return
end

local opts = { noremap = true, silent = true }
-- Telescope --
-- telescope find functions trough ripgrep
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep find_command=rg,--ignore,--hidden,--files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files find_command=rg,--ignore,--files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers find_command=rg,--ignore,--hidden,--files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fc', ':Telescope git_commits find_command=rg,--ignore,--hidden,--files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gb', ':Telescope git_branches find_command=rg,--ignore,--hidden,--files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader><leader>', ':Telescope git_files find_command=rg,--ignore,--hidden,--files<CR>', opts)

--[[ Setup telescope ]]--
telescope.setup {
    defaults = {
        sorting_strategy = 'ascending',
        layout_config = {
            horizontal = {
                prompt_position = "top"
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}

-- require('telescope').load_extension('fzf')
