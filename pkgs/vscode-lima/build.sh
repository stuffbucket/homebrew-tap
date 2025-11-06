#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
ROOT_DIR="${BUILD_DIR}/root"
SCRIPTS_DIR="${BUILD_DIR}/scripts"

echo "Building VS Code Lima installer package..."

# Extract version from Formula
VERSION=$(grep '^ *version' "${SCRIPT_DIR}/../../Formula/vscode-lima.rb" | head -1 | cut -d'"' -f2)
if [ -z "${VERSION}" ]; then
  echo "Error: Could not extract version from Formula/vscode-lima.rb"
  exit 1
fi
echo "Version: ${VERSION}"

# Get current git commit hash
GIT_HASH=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
echo "Building from commit: ${GIT_HASH}"

# Clean and create build directories
rm -rf "${BUILD_DIR}"
mkdir -p "${ROOT_DIR}"
mkdir -p "${SCRIPTS_DIR}"

# Copy postinstall script
cp "${SCRIPT_DIR}/postinstall" "${SCRIPTS_DIR}/postinstall"
chmod +x "${SCRIPTS_DIR}/postinstall"

# Create empty payload (all work done in postinstall)
mkdir -p "${ROOT_DIR}/tmp/.stuffbucket-vscode-lima"

# Create build metadata file
cat > "${SCRIPT_DIR}/.build-metadata" <<EOF
VERSION=${VERSION}
GIT_HASH=${GIT_HASH}
BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
FORMULA_FILE=Formula/vscode-lima.rb
EOF

# Build component package
pkgbuild --root "${ROOT_DIR}" \
         --scripts "${SCRIPTS_DIR}" \
         --identifier "com.stuffbucket.vscode-lima" \
         --version "0.0.1" \
         --install-location "/" \
         "${BUILD_DIR}/vscode-lima.pkg"

# Build product package with distribution
productbuild --distribution "${SCRIPT_DIR}/distribution.xml" \
             --resources "${SCRIPT_DIR}" \
             --package-path "${BUILD_DIR}" \
             --version "0.0.1" \
             "${SCRIPT_DIR}/stuffbucket-vscode-lima-0.0.1.pkg"

echo "Package built: ${SCRIPT_DIR}/stuffbucket-vscode-lima-0.0.1.pkg"
