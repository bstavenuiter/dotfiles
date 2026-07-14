-- wt — neovim side of the worktree workspace launcher (see ~/code/dotfiles/tmux/wt).
--
-- Called once, at startup, by `nvim "+lua require('wt').start()"`. Drives the
-- editor into the working state:
--   tab 1: plan file open (left) + sidekick Claude split (right), focus in editor
--   tab 2: `npm run dev` terminal (only when the project defines a dev script)

local M = {}

--- Locate the ticket plan for this worktree: a *plan*.md at the root, else under
--- docs/plans/. Returns an absolute path, or nil when there is no plan.
---@param cwd string
---@return string?
local function find_plan(cwd)
  local candidates = vim.fn.glob(cwd .. "/*plan*.md", false, true)
  if #candidates == 0 then
    candidates = vim.fn.glob(cwd .. "/docs/plans/*plan*.md", false, true)
  end
  table.sort(candidates)
  return candidates[1]
end

--- Whether package.json declares a `dev` script.
---@param cwd string
---@return boolean
local function has_dev_script(cwd)
  local pkg = cwd .. "/package.json"
  if vim.fn.filereadable(pkg) == 0 then
    return false
  end
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(pkg), "\n"))
  end)
  return ok
    and type(data) == "table"
    and type(data.scripts) == "table"
    and data.scripts.dev ~= nil
end

function M.start()
  local cwd = vim.fn.getcwd()

  -- sidekick is lazy-loaded on keys, so make sure it's available first.
  pcall(function()
    require("lazy").load({ plugins = { "sidekick.nvim" } })
  end)

  local plan = find_plan(cwd)
  if plan then
    -- Read the plan in the left editor pane.
    vim.cmd.edit(vim.fn.fnameescape(plan))
  end

  -- Start a FRESH Claude session for this worktree, bypassing sidekick's session
  -- picker. `cli.send`/`cli.show` route through the picker, which lists every
  -- running `claude` process on the machine; attaching a new state (session=nil)
  -- keyed to the current cwd always spawns a new one, no prompt. Focus stays in
  -- the editor.
  -- Register session backends (terminal/tmux/...). Normally triggered lazily by
  -- Session.sessions(), which the direct-attach path below skips.
  require("sidekick.cli.session").setup()
  local claude = require("sidekick.config").get_tool("claude")
  local state = require("sidekick.cli.state").attach({ tool = claude }, { show = true, focus = false })

  if plan and state and state.session then
    -- Pre-fill the pickup prompt but do NOT submit — the trailing "\n" is a
    -- newline, not Enter (submit sends "\r"). Sidekick's readiness queue lands
    -- the text once the TUI is up, so there's no startup race.
    state.session:send("Implement the plan in " .. vim.fn.fnamemodify(plan, ":t") .. "\n")
  end

  -- `npm run dev` in a second tab, only for node projects that define it.
  if has_dev_script(cwd) then
    vim.cmd("tabnew | terminal")
    local job = vim.b.terminal_job_id
    if job then
      -- Small delay so the shell prompt is ready before we type.
      vim.defer_fn(function()
        pcall(vim.fn.chansend, job, "npm run dev\n")
      end, 300)
    end
    vim.cmd("tabfirst")
  end
end

return M
