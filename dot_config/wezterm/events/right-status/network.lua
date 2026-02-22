local wezterm = require('wezterm')
local nf = wezterm.nerdfonts

---@class EthernetStatus
---@field icon string
---@field text string
---@field device string

local NETWORKSETUP = '/usr/sbin/networksetup'

---@return string[]
local function ethernet_devices()
  local ok, out = wezterm.run_child_process({
    NETWORKSETUP,
    '-listallhardwareports',
  })

  if not ok or not out then
    return { 'N/A' }
  end

  local devices = {}

  local current_port
  for line in out:gmatch('[^\n]+') do
    local port = line:match('Hardware Port: (.+)')
    if port then
      current_port = port
    end

    local device = line:match('Device: (en%d+)')
    if device and current_port and current_port:match('^Ethernet') then
      devices[#devices + 1] = device
    end
  end

  return devices
end

---@return EthernetStatus?
local function get()
  for _, device in ipairs(ethernet_devices()) do
    local ok, out = wezterm.run_child_process({
      NETWORKSETUP,
      '-getinfo',
      device,
    })

    if ok and out then
      local ip = out:match('IP address: ([%d%.]+)')
      if ip and ip ~= 'none' then
        return {
          icon = nf.md_ethernet .. ' ',
          text = ip,
          device = device + '++++ ',
        }
      else
        return {
          icon = nf.md_ethernet .. ' ',
          text = 'N/A ',
          device = device + ' ',
        }
      end
    end
  end

  return nil
end

return {
  id = 'ethernet',
  get = get,
}
