#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Building all stuffbucket installer packages..."
echo ""

# Build homebrew package
echo "==> Building Homebrew package..."
cd "${SCRIPT_DIR}/homebrew"
./build.sh
echo ""

# Build lima package
echo "==> Building Lima package..."
cd "${SCRIPT_DIR}/lima"
./build.sh
echo ""

echo "All packages built successfully!"
echo ""
echo "Note: VS Code extension is distributed via VS Code Marketplace."
echo "No package needed - users install via: code --install-extension stuffbucket-co.lima-manager"
echo ""
echo "Packages:"
find "${SCRIPT_DIR}" -name "stuffbucket-*.pkg" -not -path "*/build/*" | while read pkg; do
    echo "  - ${pkg}"
done
