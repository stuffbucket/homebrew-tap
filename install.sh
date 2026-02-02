#!/bin/bash
# Installer for stuffbucket/tap/coop
# Designed to work with: curl -fsSL <url> | bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Abort on error
abort() {
    echo -e "${RED}Error:${NC} $1" >&2
    exit 1
}

info() {
    echo -e "${GREEN}==>${NC} $1"
}

warn() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

note() {
    echo -e "${BLUE}Note:${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    abort "This installer is designed for macOS only."
fi

# Check for Bash
if [ -z "${BASH_VERSION:-}" ]; then
    abort "Bash is required to run this script."
fi

# Detect and setup Homebrew PATH (handles both Intel and Apple Silicon)
info "Checking for Homebrew..."

# Function to check if brew is working
check_brew() {
    command -v brew &> /dev/null && brew --version &> /dev/null
}

# Try to find Homebrew
if [[ -x "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
    # Intel
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Verify brew is now available
if ! check_brew; then
    abort "Homebrew is not installed. Please install it first:

    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"

After installing Homebrew, run this installer again."
fi

BREW_PATH=$(command -v brew)
info "Found Homebrew at: $BREW_PATH"

# Check if colima is running (warn if so)
if command -v colima &> /dev/null && colima status &> /dev/null 2>&1; then
    warn "Colima is currently running."
    note "If colima gets upgraded, you may need to restart it afterward."
    echo ""
    echo -n "Continue anyway? [y/N] "
    read -r -n 1 response
    echo
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        abort "Installation cancelled. Stop colima with: colima stop"
    fi
fi

# Update Homebrew
info "Updating Homebrew..."
if ! brew update; then
    warn "Failed to update Homebrew, but continuing anyway."
    note "If you run into issues, try: brew update && brew doctor"
fi

echo ""
info "Installing dependencies..."

# Install colima (which brings lima-vm as dependency)
if brew list colima &> /dev/null; then
    info "colima is already installed"
else
    info "Installing colima (includes lima-vm)..."
    if ! brew install colima; then
        abort "Failed to install colima. Check the output above for details."
    fi
fi

# Add the tap
info "Adding stuffbucket/tap..."
if brew tap | grep -q "^stuffbucket/tap$"; then
    info "stuffbucket/tap is already tapped"
else
    if ! brew tap stuffbucket/tap; then
        abort "Failed to add tap. Ensure github.com/stuffbucket/homebrew-tap exists."
    fi
fi

# Install coop
info "Installing coop..."
if brew list stuffbucket/tap/coop &> /dev/null; then
    info "coop is already installed, checking for updates..."
    brew upgrade stuffbucket/tap/coop 2>&1 | grep -v "already installed" || true
else
    if ! brew install stuffbucket/tap/coop; then
        abort "Failed to install coop. See output above for details."
    fi
fi

echo ""
info "Installation complete"
echo ""

# Verify installation
if command -v coop &> /dev/null; then
    info "Verification: coop command is available"
    if coop --version &> /dev/null; then
        COOP_VERSION=$(coop --version 2>/dev/null || echo "version unknown")
        echo "  $COOP_VERSION"
    fi
else
    warn "coop command not found in PATH"
    note "Restart your shell or run: eval \"\$(brew shellenv)\""
fi
