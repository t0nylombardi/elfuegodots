local wezterm = require('wezterm')

local launch_menu = {
  { label = 'Bash', args = { 'bash', '-l' } },
  { label = 'Zsh', args = { 'zsh', '-l' } },
}

local find_nu = 'command -v nu'
if wezterm.target_triple:find('apple%-darwin') then
  find_nu = 'PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"; ' .. find_nu
end

local found, output = wezterm.run_child_process({ '/bin/sh', '-c', find_nu })
if found then
  local nu = output:match('^([^\r\n]+)')
  if nu then
    table.insert(launch_menu, 2, { label = 'Nushell', args = { nu, '-l' } })
  end
end

return {
  default_prog = { 'zsh', '-l' },
  launch_menu = launch_menu,
}
