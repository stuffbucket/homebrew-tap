#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
ROOT_DIR="${BUILD_DIR}/root"
SCRIPTS_DIR="${BUILD_DIR}/scripts"

echo "Building Homebrew installer package..."

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
mkdir -p "${ROOT_DIR}/tmp/.stuffbucket-homebrew"

# Create build metadata file
cat > "${SCRIPT_DIR}/.build-metadata" <<EOF
VERSION=1.0.0
GIT_HASH=${GIT_HASH}
BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

# Build component package
pkgbuild --root "${ROOT_DIR}" \
         --scripts "${SCRIPTS_DIR}" \
         --identifier "com.stuffbucket.homebrew" \
         --version "1.0.0" \
         --install-location "/" \
         "${BUILD_DIR}/homebrew.pkg"

# Build product package with distribution
productbuild --distribution "${SCRIPT_DIR}/distribution.xml" \
             --resources "${SCRIPT_DIR}" \
             --package-path "${BUILD_DIR}" \
             --version "1.0.0" \
             "${SCRIPT_DIR}/stuffbucket-homebrew-1.pkg"

echo "Package built: ${SCRIPT_DIR}/stuffbucket-homebrew-1.pkg"
