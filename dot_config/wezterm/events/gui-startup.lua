local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

local DEFAULT_WIDTH = 1240
local DEFAULT_HEIGHT = 1435

M.setup = function()
  wezterm.on('gui-startup', function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    local gui_window = window:gui_window()
    gui_window:set_inner_size(DEFAULT_WIDTH, DEFAULT_HEIGHT)
    gui_window:set_position(0, 0)
  end)
end

return M
