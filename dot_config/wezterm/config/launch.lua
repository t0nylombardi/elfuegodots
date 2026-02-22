local options = {
  default_prog = {},
  launch_menu = {},
}

options.default_prog = { 'zsh', '-l' }
options.launch_menu = {
  { label = 'Bash',    args = { 'bash', '-l' } },
  { label = 'Nushell', args = { '/opt/homebrew/bin/nu', '-l' } },
  { label = 'Zsh',     args = { 'zsh', '-l' } },
}

return options
