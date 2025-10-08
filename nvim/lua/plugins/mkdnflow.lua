-- note taking
return {
	{ "jakewvincent/mkdnflow.nvim",

		opts = {
			rocks = "luautf8", -- Ensures optional luautf8 dependency is installed
		},

		config = function()
			local opts = { noremap = true, silent = true }
			local keymap = vim.api.nvim_set_keymap
			keymap(
				"n",
				"<leader>zf",
				':lua require("telescope.builtin").find_files({cwd = "~/leadsio/notes/zettelkasten/", hidden=true, layout_config={prompt_position="top"}})<CR>',
				opts
			)

			require("mkdnflow").setup({
				mappings = {
					MkdnEnter = { { "i", "n", "v" }, "<CR>" }, -- This monolithic command has the aforementioned
					-- insert-mode-specific behavior and also will trigger row jumping in tables. Outside
					-- of lists and tables, it behaves as <CR> normally does.
					-- MkdnNewListItem = {'i', '<CR>'} -- Use this command instead if you only want <CR> in
					-- insert mode to add a new list item (and behave as usual outside of lists).
				},
				new_file_template = {
					use_template = true,
					placeholders = {
						before = {
							title = "link_title",
							date = "os_date",
						},
						after = {},
					},
					template = [[title: {{ title }}\
date: {{ date }}\
participants:\
documentation:\
 
---
 
### Action points
]],
				},
			})
		end,
	}
}
