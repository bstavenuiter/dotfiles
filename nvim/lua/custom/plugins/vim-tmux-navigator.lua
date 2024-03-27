return {
	'christoomey/vim-tmux-navigator',
	vim.keymap.set('n', 'C-h', ":TmuxNavigateLeft<cr>", { desc = "Navigate to the left pane" }),
	vim.keymap.set('n', 'C-j', ":TmuxNavigateDown<cr>", { desc = "Navigate to the lower pane" }),
	vim.keymap.set('n', 'C-k', ":TmuxNavigateUp<cr>", { desc = "Navigate to the upper pane" }),
	vim.keymap.set('n', 'C-l', ":TmuxNavigateRight<cr>", { desc = "Navigate to the right pane" }),
}
