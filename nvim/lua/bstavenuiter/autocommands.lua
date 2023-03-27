local group = vim.api.nvim_create_augroup(
	"FiletypeRecog",
	{
		clear = true,
	}
)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.env",
	command = "set ft=sh",
	group = group,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "Dockerfile",
	command = "set ft=dockerfile",
	group = group,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "Makefile",
	command = "set ft=make",
	group = group,
})
