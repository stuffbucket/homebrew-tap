#!/bin/bash
# Lima Complete Installation Script
# Installs Lima and VS Code Lima Manager extension

set -e

echo "🚀 Installing Lima and VS Code Extension..."
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "📦 Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# Tap stuffbucket/tap
echo ""
echo "📌 Tapping stuffbucket/tap..."
brew tap stuffbucket/tap

# Install Lima
echo ""
echo "🐧 Installing Lima..."
brew install stuffbucket/tap/lima

# Install VS Code extension
echo ""
if command -v code &> /dev/null; then
    echo "📝 Installing VS Code Lima Manager extension..."
    code --install-extension stuffbucket-co.lima-manager
    echo ""
    echo "✅ Installation complete!"
    echo ""
    echo "Lima is installed and the VS Code extension is ready."
    echo "The extension will auto-update through VS Code."
else
    echo "⚠️  VS Code not found."
    echo ""
    echo "✅ Lima is installed!"
    echo ""
    echo "To install the VS Code extension later:"
    echo "  1. Install VS Code from https://code.visualstudio.com/"
    echo "  2. Run: code --install-extension stuffbucket-co.lima-manager"
    echo "  OR search for 'Lima Manager' in VS Code Extensions"
fi
