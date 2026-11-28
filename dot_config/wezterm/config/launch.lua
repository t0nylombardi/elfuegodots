local wezterm = require('wezterm')

local launch_menu = {
  { label = 'Bash', args = { 'bash', '-l' } },
  { label = 'Zsh', args = { 'zsh', '-l' } },
}

local find_nu = 'command -v nu'
if wezterm.target_triple:find('apple%-darwin') then
  find_nu = 'PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"; ' .. find_nu
end

-- require() cannot yield while loading this module.
local lookup = io.popen(find_nu, 'r')
if lookup then
  local nu = lookup:read('*l')
  local found = lookup:close()
  if found and nu and nu ~= '' then
    table.insert(launch_menu, 2, { label = 'Nushell', args = { nu, '-l' } })
  end
end

return {
  default_prog = { 'zsh', '-l' },
  launch_menu = launch_menu,
}
