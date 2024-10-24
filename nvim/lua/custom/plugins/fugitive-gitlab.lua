return {
	"shumphrey/fugitive-gitlab.vim",
	config = function()
		vim.g.fugitive_gitlab_domains = { ["gitlab.leadsio.dev"] = "https://gitlab.leadsio.dev" }
	end,
}
