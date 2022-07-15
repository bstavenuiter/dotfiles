local lint_status_ok, lint = pcall(require, "lint")
if not lint_status_ok then
	return
end

lint.linters_by_ft = {
  markdown = {'vale',},
  php = {'phpcs',},
  js = {'eslint',},
}

local phpcs = require('lint.linters.phpcs')
phpcs.args = {
  '-q',
  '--config=vendor/socialblue/php-code-style/easy-coding-standard.php',
  '--report=json',
}

-- au BufWritePost <buffer> lua require('lint').try_lint()
-- vim.cmd([[
-- autocmd BufWritePost *.php silent! execute "!php ./vendor/bin/ecs check -q --fix --config=./vendor/socialblue/php-code-style/easy-coding-standard.php % >/dev/null 2>&1" | redraw!
-- ]])
