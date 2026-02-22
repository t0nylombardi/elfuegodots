local wezterm        = require('wezterm')
local Cells          = require('utils.cells')
local OptsValidator  = require('utils.opts-validator')
local macchiato      = require('colors.custom')

local Battery        = require('events.right-status.battery')
local Network        = require('events.right-status.network')
local Date           = require('events.right-status.date')

local attr           = Cells.attr
local nf             = wezterm.nerdfonts

local M              = {}

-- ======================================================
-- Options
-- ======================================================

---@alias Event.RightStatusOptions { date_format?: string }

local EVENT_OPTS     = {
  schema = {
    {
      name = 'date_format',
      type = 'string',
      default = '%a %H:%M:%S',
    },
  },
}
EVENT_OPTS.validator = OptsValidator:new(EVENT_OPTS.schema)

-- ======================================================
-- Layout
-- ======================================================

local COLORS         = {
  date      = { fg = '#fab387', bg = macchiato.base },
  battery   = { fg = '#f9e2af', bg = macchiato.base },
  network   = { fg = '#94e2d5', bg = macchiato.base },
  separator = { fg = '#74c7ec', bg = macchiato.base },
}

local cells          = Cells:new()

cells
    :add_segment('network_icon', '', COLORS.network)
    :add_segment('network_text', '', COLORS.network, attr(attr.intensity('Bold')))
    :add_segment('separator', ' ' .. nf.oct_dash .. '  ', COLORS.separator)
    :add_segment('date_icon', '', COLORS.date, attr(attr.intensity('Bold')))
    :add_segment('date_text', '', COLORS.date, attr(attr.intensity('Bold')))
    :add_segment('battery_icon', '', COLORS.battery)
    :add_segment('battery_text', '', COLORS.battery, attr(attr.intensity('Bold')))

-- ======================================================
-- Render
-- ======================================================

local function render(window, date_format)
  local network = Network.get()
  local date    = Date.get(date_format)
  local battery = Battery.get()

  cells
      :update_segment_text('network_icon', network and network.icon or '')
      :update_segment_text('network_text', network and network.text or '')
      :update_segment_text('date_icon', date.icon)
      :update_segment_text('date_text', date.text)
      :update_segment_text('battery_icon', battery and battery.icon or '')
      :update_segment_text('battery_text', battery and battery.text or '')

  local segments = {}

  if network then
    segments[#segments + 1] = 'network_icon'
    segments[#segments + 1] = 'network_text'
    segments[#segments + 1] = 'separator'
  end

  segments[#segments + 1] = 'date_icon'
  segments[#segments + 1] = 'date_text'

  if battery then
    segments[#segments + 1] = 'separator'
    segments[#segments + 1] = 'battery_icon'
    segments[#segments + 1] = 'battery_text'
  end

  window:set_right_status(wezterm.format(cells:render(segments)))
end

-- ======================================================
-- Setup
-- ======================================================

function M.setup(opts)
  local valid, err = EVENT_OPTS.validator:validate(opts or {})
  if err then
    wezterm.log_error(err)
  end

  wezterm.on('update-right-status', function(window)
    render(window, valid.date_format)
  end)
end

return M
