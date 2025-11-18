#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# List of files/dirs to symlink into $HOME
FILES_TO_LINK=(
    ".bashrc"
    ".gitconfig"
)

# List of config directories to symlink into ~/.config
CONFIG_DIRS=(
    "nvim"
)

backup_file() {
    local filepath="$1"
    if [ -e "$filepath" ] && [ ! -L "$filepath" ]; then
        echo "Backing up existing $(basename "$filepath") → $filepath.backup"
        mv "$filepath" "$filepath.backup"
    fi
}

link_file() {
    local source="$1"
    local target="$2"

    backup_file "$target"

    echo "Linking $target → $source"
    ln -sf "$source" "$target"
}

echo "=== Bootstrapping dotfiles from $DOTFILES_DIR ==="

# --- Home directory dotfiles ---
for file in "${FILES_TO_LINK[@]}"; do
    link_file "$DOTFILES_DIR/$file" "$HOME/$file"
done

# --- ~/.config directories (like Neovim) ---
mkdir -p "$HOME/.config"

for dir in "${CONFIG_DIRS[@]}"; do
    link_file "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
done

echo "Done! Dotfiles successfully linked."

