local wezterm = require('wezterm')

local function find_executable(name)
  local path = os.getenv('PATH') or ''

  if wezterm.target_triple:find('apple%-darwin') then
    path = path .. ':/opt/homebrew/bin:/usr/local/bin'
  end

  for directory in path:gmatch('[^:]+') do
    local executable = directory .. '/' .. name
    local file = io.open(executable, 'r')

    if file then
      file:close()
      return executable
    end
  end

  return nil
end

local launch_menu = {
  { label = 'Bash', args = { 'bash', '-l' } },
  { label = 'Zsh', args = { 'zsh', '-l' } },
}

local nu = find_executable('nu')

if nu then
  table.insert(launch_menu, 2, {
    label = 'Nushell',
    args = { nu, '-l' },
  })
end

return {
  default_prog = { 'zsh', '-l' },
  launch_menu = launch_menu,
}
