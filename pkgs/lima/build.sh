#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
ROOT_DIR="${BUILD_DIR}/root"
SCRIPTS_DIR="${BUILD_DIR}/scripts"

echo "Building Lima installer package..."

# Query version from brew (single source of truth)
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not found. Please install Homebrew first."
    exit 1
fi

# Tap the local repo
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "${SCRIPT_DIR}/../..")"
brew tap stuffbucket/tap "${REPO_ROOT}" 2>/dev/null || true

VERSION=$(brew info --json=v2 stuffbucket/tap/lima | jq -r '.formulae[0].versions.stable')
if [ -z "${VERSION}" ] || [ "${VERSION}" = "null" ]; then
    echo "Error: Could not determine lima version from brew"
    exit 1
fi
echo "Formula version: ${VERSION}"

# Extract major version for package filename (e.g., "2.0.0-beta.0.3" -> "2")
MAJOR_VERSION=$(echo "${VERSION}" | cut -d. -f1)
echo "Package major version: ${MAJOR_VERSION}"

# Use stable semantic version for package metadata (e.g., "2.0.0")
# This is the installer wrapper version, not the software version
PKG_VERSION="${MAJOR_VERSION}.0.0"
echo "Package metadata version: ${PKG_VERSION}"

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
mkdir -p "${ROOT_DIR}/tmp/.stuffbucket-lima"

# Create build metadata file
cat > "${SCRIPT_DIR}/.build-metadata" <<EOF
VERSION=${VERSION}
GIT_HASH=${GIT_HASH}
BUILD_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
FORMULA_FILE=Formula/lima.rb
EOF

# Build component package
pkgbuild --root "${ROOT_DIR}" \
         --scripts "${SCRIPTS_DIR}" \
         --identifier "com.stuffbucket.lima" \
         --version "${PKG_VERSION}" \
         --install-location "/" \
         "${BUILD_DIR}/lima.pkg"

# Build product package with distribution
productbuild --distribution "${SCRIPT_DIR}/distribution.xml" \
             --resources "${SCRIPT_DIR}" \
             --package-path "${BUILD_DIR}" \
             --version "${PKG_VERSION}" \
             "${SCRIPT_DIR}/stuffbucket-lima-${MAJOR_VERSION}.pkg"

echo "Package built: ${SCRIPT_DIR}/stuffbucket-lima-${MAJOR_VERSION}.pkg"
