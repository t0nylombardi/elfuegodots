# EL FUEGO DOTS

Dotfiles managed with [chezmoi](https://www.chezmoi.io/).

This repo configures shell, terminal, editor, tmux, and package bootstrap tooling with a Catppuccin-leaning setup and a few custom workflow helpers.

## What's managed

- `zsh` login and interactive shell config (`dot_zprofile`, `dot_zshrc`)
- Terminal emulators:
  - WezTerm (`dot_config/wezterm/...`) <- primary terminal>
  - Ghostty (`dot_config/ghostty/config`)
  - Alacritty (`dot_config/alacritty/alacritty.toml`)
- `tmux` config + plugin manager (`dot_config/tmux/tmux.conf`)
- Neovim config (`dot_config/nvim/...`)
- Shell aliases/functions (`dot_config/dotfiles/...`)
- Homebrew + casks + editor extensions bootstrap (`Brewfile`)
- Utility scripts (for example, tmux session picker in `dot_config/scripts/executable_tmux-sessionizer`)

## Prerequisites

- `git`
- `chezmoi`
- Homebrew (recommended for macOS if you want to use `Brewfile`)

## Bootstrap on a new machine

Initialize the source checkout and review what chezmoi would install.

```sh
chezmoi init https://github.com/t0nylombardi/elfuegodots.git
chezmoi diff
```

On macOS, install the packages from the Brewfile.

```sh
brew bundle --file "$(chezmoi source-path)/Brewfile"
```

On Debian, install the shell and terminal tools and Neovim plugin build dependencies.

```sh
sudo apt update
sudo apt install zsh tmux fzf ripgrep fd-find zoxide zsh-syntax-highlighting \
  ncurses-term build-essential git unzip ca-certificates curl
```

Debian provides `fd-find` as `fdfind`. Follow the Neovim instructions below
to install a compatible editor. GUI terminal emulators are optional.

After reviewing the diff and installing dependencies, apply the files and start
a login shell.

```sh
chezmoi apply
exec zsh -l
```

## Neovim on Debian

This configuration requires Neovim 0.11.3 or newer. From the dotfiles checkout
on Debian 12 or 13, run the installer to get the pinned upstream release on
amd64 or arm64. It verifies the release checksum, installs under
`~/.local/opt/neovim`, and links `~/.local/bin/nvim` as your user.

```sh
"$(chezmoi source-path)/bootstrap/install-neovim.sh"
"$HOME/.local/bin/nvim" --version
```

The Zsh configuration puts `~/.local/bin` on `PATH` when you start a new shell.
You can use APT directly on Debian releases that provide Neovim 0.11.3 or newer.
If you already have the plugins installed, run `:Lazy restore` to apply the
updated Treesitter pin.

## Notes

- Some plugin directories are vendored in-tree under `dot_config/tmux/plugins/...`.
- This is a personal setup; feel free to fork and trim tools/plugins you do not use.
