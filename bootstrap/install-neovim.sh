#!/bin/sh
set -eu

version=v0.12.4
if [ "$(uname -s)" != Linux ]; then
  printf '%s\n' 'This installer uses the upstream Linux release. On macOS, use the Brewfile.' >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64)
    arch=x86_64
    sha256=012bf3fcac5ade43914df3f174668bf64d05e049a4f032a388c027b1ebd78628
    ;;
  aarch64)
    arch=arm64
    sha256=ceb7e88c6b681f0515d135dcdfad54f5eb4373b25ce6172197cd9a69c758063f
    ;;
  *)
    printf 'No upstream Neovim tarball for %s.\n' "$(uname -m)" >&2
    exit 1
    ;;
esac

release="nvim-linux-$arch"
archive="$release.tar.gz"
install_root="$HOME/.local/opt/neovim"
install_dir="$install_root/$version-$arch"
bin_dir="$HOME/.local/bin"
launcher="$bin_dir/nvim"

if [ -e "$launcher" ] || [ -L "$launcher" ]; then
  case "$(readlink "$launcher" || true)" in
    "$install_root"/v*-"$arch"/bin/nvim) ;;
    *)
      printf 'Move the existing %s aside before installing.\n' "$launcher" >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$install_root" "$bin_dir"
if [ ! -d "$install_dir" ]; then
  work_dir=$(mktemp -d "$install_root/.download.XXXXXXXX")
  trap 'rm -rf -- "$work_dir"' EXIT
  trap 'exit 1' HUP INT TERM

  curl --fail --location --silent --show-error --retry 3 \
    "https://github.com/neovim/neovim/releases/download/$version/$archive" \
    --output "$work_dir/$archive"
  printf '%s  %s\n' "$sha256" "$work_dir/$archive" | sha256sum --check
  tar -xzf "$work_dir/$archive" -C "$work_dir"
  "$work_dir/$release/bin/nvim" --headless -u NONE '+quit'

  # Another installer may have moved the same release into place while we downloaded.
  mv -T -- "$work_dir/$release" "$install_dir" || [ -x "$install_dir/bin/nvim" ]
fi

"$install_dir/bin/nvim" --headless -u NONE '+quit'
ln -sfnT -- "$install_dir/bin/nvim" "$launcher"
printf 'Neovim %s is available at %s\n' "$version" "$launcher"
