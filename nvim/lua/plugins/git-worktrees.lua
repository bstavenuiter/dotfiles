return {
	{
		"ThePrimeagen/git-worktree.nvim",

		config = function()
			require("telescope").load_extension("git_worktree")
		end,

		keys = {
			{
				"<leader>cw",
				function()
					require("telescope").extensions.git_worktree.create_git_worktree()
				end,
				mode = "n",
			},
			{
				"<leader>ww",
				function()
					require("telescope").extensions.git_worktree.git_worktrees()
				end,
				mode = "n",
			},
		},
	},
}
