# EL FUEGO DOTS(dotfiles)

Ddotfiles managed with [chezmoi](https://www.chezmoi.io/).

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

1. Initialize/apply this repo with chezmoi:

```bash
chezmoi init --apply <git-repo-url>
```

2. Install packages from `Brewfile` (macOS/Homebrew):

```bash
brew bundle --file ~/.local/share/chezmoi/Brewfile
```

3. Start a new shell session:

```bash
exec zsh
```

## Neovim on Debian

This configuration requires Neovim 0.11.3 or newer. From the dotfiles checkout
on Debian 12 or 13, run the installer to get the pinned upstream release on
amd64 or arm64. It verifies the release checksum, installs under
`~/.local/opt/neovim`, and links `~/.local/bin/nvim` as your user.

```sh
sudo apt install ca-certificates curl
./bootstrap/install-neovim.sh
nvim --version
```

The Zsh configuration puts `~/.local/bin` on `PATH`. Start a new login shell
if the version check still finds the APT copy. You can use APT directly on
Debian releases that provide Neovim 0.11.3 or newer. If you already have the
plugins installed, run `:Lazy restore` to apply the updated Treesitter pin.

## Notes

- Some plugin directories are vendored in-tree under `dot_config/tmux/plugins/...`.
- This is a personal setup; feel free to fork and trim tools/plugins you do not use.
