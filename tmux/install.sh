#!/bin/bash

# Tmux Kata Installer
# Quick setup for the tmux kata training system

set -e

INSTALL_DIR="$HOME/tmux-kata"
SCRIPT_NAME="tmux-kata.sh"

echo "╔════════════════════════════════════════════╗"
echo "║     Tmux Kata Training System Installer    ║"
echo "╚════════════════════════════════════════════╝"
echo

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "❌ Error: tmux is not installed"
    echo
    echo "Install tmux first:"
    echo "  Ubuntu/Debian: sudo apt install tmux"
    echo "  Fedora:        sudo dnf install tmux"
    echo "  Arch:          sudo pacman -S tmux"
    echo "  macOS:         brew install tmux"
    exit 1
fi

echo "✓ tmux found: $(tmux -V)"
echo

# Create installation directory
if [[ -d "$INSTALL_DIR" ]]; then
    echo "⚠ Directory $INSTALL_DIR already exists"
    echo -n "Remove and reinstall? [y/N] "
    read response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
        echo "✓ Removed old installation"
    else
        echo "Installation cancelled"
        exit 0
    fi
fi

mkdir -p "$INSTALL_DIR"
echo "✓ Created $INSTALL_DIR"

# Copy files (assuming they're in current directory)
if [[ -f "$SCRIPT_NAME" ]]; then
    cp "$SCRIPT_NAME" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    echo "✓ Installed $SCRIPT_NAME"
fi

if [[ -f "README.md" ]]; then
    cp "README.md" "$INSTALL_DIR/"
    echo "✓ Installed README.md"
fi

if [[ -f "TMUX-REFERENCE.md" ]]; then
    cp "TMUX-REFERENCE.md" "$INSTALL_DIR/"
    echo "✓ Installed TMUX-REFERENCE.md"
fi

# Create alias suggestion
SHELL_RC=""
if [[ -f "$HOME/.bashrc" ]]; then
    SHELL_RC="$HOME/.bashrc"
elif [[ -f "$HOME/.zshrc" ]]; then
    SHELL_RC="$HOME/.zshrc"
fi

echo
echo "═══════════════════════════════════════════"
echo "Installation Complete! 🎉"
echo "═══════════════════════════════════════════"
echo
echo "To start training:"
echo "  1. cd $INSTALL_DIR"
echo "  2. tmux"
echo "  3. ./$SCRIPT_NAME"
echo
echo "Optional: Add an alias to your shell config ($SHELL_RC):"
echo "  alias tmux-kata='cd $INSTALL_DIR && tmux new-session -s kata \; send-keys \"./$SCRIPT_NAME\" C-m'"
echo
echo "Then you can start training anytime with: tmux-kata"
echo
echo "Quick reference: cat $INSTALL_DIR/TMUX-REFERENCE.md"
echo

# Offer to add alias
if [[ -n "$SHELL_RC" ]]; then
    echo -n "Add alias to $SHELL_RC now? [y/N] "
    read response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "" >> "$SHELL_RC"
        echo "# Tmux Kata Training" >> "$SHELL_RC"
        echo "alias tmux-kata='cd $INSTALL_DIR && tmux new-session -s kata \; send-keys \"./$SCRIPT_NAME\" C-m'" >> "$SHELL_RC"
        echo "✓ Alias added to $SHELL_RC"
        echo "  Restart your shell or run: source $SHELL_RC"
    fi
fi

echo
echo "Happy learning! 🚀"
