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

# Build vscode-lima package
echo "==> Building VS Code Lima package..."
cd "${SCRIPT_DIR}/vscode-lima"
./build.sh
echo ""

echo "All packages built successfully!"
echo ""
echo "Packages:"
echo "  - ${SCRIPT_DIR}/homebrew/stuffbucket-homebrew-1.0.0.pkg"
echo "  - ${SCRIPT_DIR}/lima/stuffbucket-lima-2.0.0.pkg"
echo "  - ${SCRIPT_DIR}/vscode-lima/stuffbucket-vscode-lima-0.0.1.pkg"
