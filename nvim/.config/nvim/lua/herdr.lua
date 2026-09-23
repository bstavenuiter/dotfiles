-- Window navigation that continues into herdr panes.
--
-- herdr/bin/herdr-nav forwards ctrl+h and ctrl+l to this pane whenever it is
-- running vim, which is what lets neovim take precedence. This is the other
-- half: once there is no window left in that direction, hand the move back to
-- herdr so focus crosses into the neighbouring pane.
--
-- The move goes over herdr's API socket rather than through the herdr CLI: the
-- binary costs ~24ms to start, which is most of the delay you feel on a pane
-- switch, while the socket write is free.
--
-- Outside herdr HERDR_PANE_ID is unset and this is a plain wincmd.

local M = {}

local directions = { h = "left", l = "right", j = "down", k = "up" }

local function focus_pane(pane, direction)
  local sock = vim.env.HERDR_SOCKET_PATH or (vim.env.HOME .. "/.config/herdr/herdr.sock")
  local pipe = vim.uv.new_pipe(false)
  if not pipe then
    return
  end

  local request = vim.json.encode({
    id = "nvim-herdr",
    method = "pane.focus_direction",
    params = { pane_id = pane, direction = direction },
  })

  pipe:connect(sock, function(err)
    if err then
      return pipe:close()
    end
    -- Read the reply before closing, so the write cannot be dropped.
    pipe:read_start(function()
      pipe:read_stop()
      pipe:close()
    end)
    pipe:write(request .. "\n")
  end)
end

function M.move(key)
  local from = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(key)
  if vim.api.nvim_get_current_win() ~= from then
    return
  end

  local pane = vim.env.HERDR_PANE_ID
  if pane then
    focus_pane(pane, directions[key])
  end
end

return M
