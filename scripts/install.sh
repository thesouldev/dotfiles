#!/bin/bash
# Symlink dotfiles into place. Safe to re-run.

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
    local src="$DOTFILES/$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        mv "$dest" "$dest.bak"
        echo "backed up existing $dest -> $dest.bak"
    fi

    ln -s "$src" "$dest"
    echo "linked $dest -> $src"
}

link herdr/config.toml "$HOME/.config/herdr/config.toml"
