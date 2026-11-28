local wezterm = require('wezterm')
local platform = require('utils.platform')

local font_family = 'MesloLGS Nerd Font Mono'

local is_macos = wezterm.target_triple:match('apple%-darwin$') ~= nil
local font_size = is_macos and 18 or 14

return {
  font = wezterm.font({
    family = font_family,
    weight = 'Regular',
  }),
  font_size = font_size,

  --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
  freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
  freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
