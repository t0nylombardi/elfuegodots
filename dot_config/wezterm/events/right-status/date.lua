local wezterm = require('wezterm')

---@param format string
---@return { icon: string, text: string }
local function get(format)
  return {
    icon = wezterm.nerdfonts.fa_calendar .. ' ',
    text = wezterm.strftime(format) .. ' ',
  }
end

return {
  id = 'date',
  get = get,
}
