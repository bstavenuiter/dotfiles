return  
{ "akinsho/toggleterm.nvim",
    version = '*',
    config = function()
	require("toggleterm").setup()

	local terminal_ok, terminal = pcall(require, "toggleterm.terminal")
	if not terminal_ok then
		return
	end

	Terminal = terminal.Terminal
	local lazygit = Terminal:new({
	    cmd = "lazygit",
	    hidden = true,
	    direction = "float",
	    float_opts = {
		border = "double",
	    },
	})

	local term = Terminal:new({
	    hidden = true,
	    direction = "float",
	    float_opts = {
		border = "double",
	    },
	})

	function _Lazygit_toggle()
	  lazygit:toggle()
	end

	function _G.set_terminal_keymaps()
	  local opts = {buffer = 0}
	  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	  vim.keymap.set('t', '<C-q>', [[<Cmd>q<CR>]], opts)
	  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	end
	-- if you only want these mappings for toggle term use term://*toggleterm#* instead
	vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

	function _Terminal_toggle()
	    term:toggle()
	end

	vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _Lazygit_toggle()<CR>", {noremap = true, silent = true})
	vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua _Terminal_toggle()<CR>", {noremap = true, silent = true})
    end
}
