local branch = vim.fn.system('git branch --show-current')
local found_branch = branch:match("([A-Z]+-%d+)")
branch = found_branch or ""
if (branch ~= nil and branch ~= "") then
  vim.api.nvim_put({ '[' .. branch .. '] ' }, 'c', false, true)
end
