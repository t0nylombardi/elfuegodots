---@diagnostic disable: duplicate-doc-field
local wezterm = require('wezterm')
local umath = require('utils.math')

local nf = wezterm.nerdfonts

---@return string[]
local function build_icons(prefix)
  local icons = {}
  for i = 10, 90, 10 do
    icons[#icons + 1] = nf[prefix .. '_' .. i]
  end
  icons[#icons + 1] = nf[prefix]
  return icons
end

local ICONS = {
  charging    = build_icons('md_battery_charging'),
  discharging = build_icons('md_battery'),
}

---@class BatteryStatus
---@field icon string
---@field text string

---@return BatteryStatus?
local function get()
  local batteries = wezterm.battery_info()
  if #batteries == 0 then
    return nil
  end

  local b = batteries[1]
  if type(b.state_of_charge) ~= 'number' then
    return nil
  end

  local idx = umath.clamp(
    umath.round(b.state_of_charge * 10),
    1,
    10
  )

  local icons = (b.state == 'Charging')
      and ICONS.charging
      or ICONS.discharging

  local icon = icons[idx]
  if not icon then
    return nil
  end

  return {
    icon = icon .. ' ',
    text = string.format('%.0f%%', b.state_of_charge * 100),
  }
end

return {
  id = 'battery',
  get = get,
}
