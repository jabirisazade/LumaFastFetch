#!/usr/bin/env bash

set -e

echo "================================"
echo "     My Dotfiles Installer"
echo "================================"
echo

# Detect package manager
if command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"

elif command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"

elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"

elif command -v nix >/dev/null 2>&1; then
    PKG_MANAGER="nix"

else
    echo "❌ Unsupported package manager."
    exit 1
fi

echo "✓ Package manager: $PKG_MANAGER"
echo

# Install Kitty
if command -v kitty >/dev/null 2>&1; then
    echo "✓ Kitty is already installed."
else
    echo "→ Kitty is not installed. Installing..."

    case "$PKG_MANAGER" in
        pacman)
            sudo pacman -S --needed kitty
            ;;
        apt)
            sudo apt update
            sudo apt install -y kitty
            ;;
        dnf)
            sudo dnf install -y kitty
            ;;
        nix)
            nix profile install nixpkgs#kitty
            ;;
    esac
fi

# Install Fastfetch
if command -v fastfetch >/dev/null 2>&1; then
    echo "✓ Fastfetch is already installed."
else
    echo "→ Fastfetch is not installed. Installing..."

    case "$PKG_MANAGER" in
        pacman)
            sudo pacman -S --needed fastfetch
            ;;
        apt)
            sudo apt update
            sudo apt install -y fastfetch
            ;;
        dnf)
            sudo dnf install -y fastfetch
            ;;
        nix)
            nix profile install nixpkgs#fastfetch
            ;;
    esac
fi

echo
echo "Installing configurations..."

# Create directories
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/kitty"

# Backup existing Fastfetch config
if [ -f "$HOME/.config/fastfetch/config.jsonc" ]; then
    cp "$HOME/.config/fastfetch/config.jsonc" \
       "$HOME/.config/fastfetch/config.jsonc.backup"
fi

if [ -f "$HOME/.config/fastfetch/girl.png" ]; then
    cp "$HOME/.config/fastfetch/girl.png" \
       "$HOME/.config/fastfetch/girl.png.backup"
fi

# Backup existing Kitty config
if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
    cp "$HOME/.config/kitty/kitty.conf" \
       "$HOME/.config/kitty/kitty.conf.backup"
fi

if [ -f "$HOME/.config/kitty/current-theme.conf" ]; then
    cp "$HOME/.config/kitty/current-theme.conf" \
       "$HOME/.config/kitty/current-theme.conf.backup"
fi

# Install Fastfetch
cp fastfetch/config.jsonc "$HOME/.config/fastfetch/"
cp fastfetch/girl.png "$HOME/.config/fastfetch/"

# Install Kitty
cp kitty/kitty.conf "$HOME/.config/kitty/"
cp kitty/current-theme.conf "$HOME/.config/kitty/"

echo
echo "================================"
echo "        Installation done!"
echo "================================"
echo
echo "✓ Kitty"
echo "✓ Fastfetch"
echo "✓ Configurations"
echo "✓ Existing configs backed up"
