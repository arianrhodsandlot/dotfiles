#!/bin/sh
set -eu

dotfiles_dir="$HOME/.config/dotfiles"
git clone https://github.com/arianrhodsandlot/dotfiles.git "$dotfiles_dir"
curl -fsSL https://mise.run | MISE_MINIMUM_RELEASE_AGE=0s sh
MISE_CONFIG_DIR="$dotfiles_dir/.config/mise" "$HOME/.local/bin/mise" bs --force-dotfiles -y
