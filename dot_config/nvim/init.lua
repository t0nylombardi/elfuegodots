if vim.fn.has 'nvim-0.11.3' == 0 then
  vim.api.nvim_err_writeln 'These dotfiles require Neovim 0.11.3 or newer. On Debian, see bootstrap/install-neovim.sh in the dotfiles repository.'
  return
end

require 'config.globals'
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'
