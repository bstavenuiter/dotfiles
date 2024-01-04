return {
    'milanglacier/yarepl.nvim',
    config = function ()

	local yarepl = require('yarepl')

	local function run_cmd_with_count(cmd)
	    return function()
		vim.cmd(string.format('%d%s', vim.v.count, cmd))
	    end
	end

	local keymap = vim.api.nvim_set_keymap
	local bufmap = vim.api.nvim_buf_set_keymap

	local ft_to_repl = {
	    r = 'radian',
	    rmd = 'radian',
	    quarto = 'radian',
	    markdown = 'radian',
	    ['markdown.pandoc'] = 'radian',
	    python = 'ipython',
	    sh = 'bash',
	    php = 'tinker',
	    REPL = '',
	}

	yarepl.setup {
	    metas = {
		aichat = { cmd = 'aichat', formatter = yarepl.formatter.bracketed_pasting },
		python = { cmd = 'python', formatter = yarepl.formatter.trim_empty_lines },
		-- bash version >= 4.4 supports bracketed paste mode. but macos
		-- shipped with bash 3.2, so we don't use bracketed paste mode for
		-- bash.
		sh = { cmd = 'bash', formatter = yarepl.formatter.trim_empty_lines },
		tinker = { cmd = {'php', 'artisan', 'tinker'}, formatter = yarepl.formatter.trim_empty_lines },
		psysh = { cmd = {'psysh'}, formatter = yarepl.formatter.trim_empty_lines },
	    }
	}

	local my_augroup = vim.api.nvim_create_augroup('MyAuGroup', { clear = true })

	vim.api.nvim_create_autocmd('FileType', {
	    pattern = { 'quarto', 'markdown', 'markdown.pandoc', 'rmd', 'python', 'sh', 'REPL', 'php' },
	    group = my_augroup,
	    desc = 'set up REPL keymap',
	    callback = function()
		local repl = ft_to_repl[vim.bo.filetype]
		bufmap(0, 'n', '<LocalLeader>rs', '', {
		    callback = run_cmd_with_count('REPLStart ' .. repl),
		    desc = 'Start an REPL',
		})
		bufmap(0, 'n', '<LocalLeader>rf', '', {
		    callback = run_cmd_with_count 'REPLFocus',
		    desc = 'Focus on REPL',
		})
		bufmap(0, 'n', '<LocalLeader>rv', '<CMD>Telescope REPLShow<CR>', {
		    desc = 'View REPLs in telescope',
		})
		bufmap(0, 'n', '<LocalLeader>rh', '', {
		    callback = run_cmd_with_count 'REPLHideOrFocus',
		    desc = 'Hide REPL',
		})
		bufmap(0, 'v', '<LocalLeader>s', '', {
		    callback = run_cmd_with_count 'REPLSendVisual',
		    desc = 'Send visual region to REPL',
		})
		bufmap(0, 'n', '<LocalLeader>ss', '', {
		    callback = run_cmd_with_count 'REPLSendLine',
		    desc = 'Send current line to REPL',
		})
		bufmap(0, 'n', '<LocalLeader>sf', '<CMD>exe "normal! ggVG\\<Esc>:REPLSendVisual\\<CR>"<CR>', {
		    desc = 'Send current line to REPL',
		})
		-- `<LocalLeader>sap` will send the current paragraph to the
		-- buffer-attached REPL, or REPL 1 if there is no REPL attached.
		-- `2<Leader>sap` will send the paragraph to REPL 2. Note that `ap` is
		-- just an example and can be replaced with any text object or motion.
		bufmap(0, 'n', '<LocalLeader>s', '', {
		    callback = run_cmd_with_count 'REPLSendOperator',
		    desc = 'Send motion to REPL',
		})
		bufmap(0, 'n', '<LocalLeader>rq', '', {
		    callback = run_cmd_with_count 'REPLClose',
		    desc = 'Quit REPL',
		})
		bufmap(0, 'n', '<LocalLeader>rc', '<CMD>REPLCleanup<CR>', {
		    desc = 'Clear REPLs.',
		})
		bufmap(0, 'n', '<LocalLeader>rS', '<CMD>REPLSwap<CR>', {
		    desc = 'Swap REPLs.',
		})
		bufmap(0, 'n', '<LocalLeader>r?', '', {
		    callback = run_cmd_with_count 'REPLStart',
		    desc = 'Start an REPL from available REPL metas',
		})
		bufmap(0, 'n', '<LocalLeader>ra', '<CMD>REPLAttachBufferToREPL<CR>', {
		    desc = 'Attach current buffer to a REPL',
		})
		bufmap(0, 'n', '<LocalLeader>rd', '<CMD>REPLDetachBufferToREPL<CR>', {
		    desc = 'Detach current buffer to any REPL',
		})
	end,
	})
    end
}


