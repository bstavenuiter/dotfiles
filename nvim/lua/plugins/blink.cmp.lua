return {
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		version = "*",

		opts = {

			-- { 'lsp', 'path', 'snippets', 'buffer' },
			sources = {
				default = function(ctx)
					local success, node = pcall(vim.treesitter.get_node)
					if vim.bo.filetype == 'markdown' then
						return { 'snippets' }
					else
						return { 'lsp', 'path', 'snippets', 'buffer' }
					end
				end
			},

            cmdline = {
                enabled = false
            },

			keymap = { preset = "default" },

			appearance = {
				-- will be removed in a future release
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "Text",
					Method = "Method",
					Function = "Function",
					Field = 'Field',
					Variable = 'Variable',
					Property = 'Property',
					Class = 'Class',
					Interface = 'Interface',
					Struct = 'Struct',
					Module = 'Module',
					Unit = 'Unit',
					Value = 'Value',
					Enum = 'Enum',
					EnumMember = 'EnumMember',
					Keyword = 'Keyword',
					Constant = 'Constant',
					Snippet = 'Snippet',
					Color = 'Color',
					File = 'File',
					Reference = 'Reference',
					Folder = 'Folder',
					Event = 'Event',
					Operator = 'Operator',
					TypeParameter = 'TypeParameter',
				}
			},

			signature = { enabled = true },

		},
	},
}
