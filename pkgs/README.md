# stuffbucket Installer Packages

This directory contains macOS `.pkg` installer packages for stuffbucket's Homebrew tap and formulas.

## Packages

### 1. stuffbucket-homebrew-1.0.0.pkg
**Base Package** - Must be installed first

- Installs or updates Homebrew
- Configures shell environment (`.zshrc`, `.bashrc`, `.bash_profile`)
- Supports both Intel and Apple Silicon Macs
- No dependencies

### 2. stuffbucket-lima-2.0.0.pkg
**Lima Virtual Machines**

- Installs Lima from stuffbucket/tap
- Taps stuffbucket/tap repository
- **Requires:** Homebrew (checks during installation)
- Version: 2.0.0-beta.0.1-fork

### 3. stuffbucket-vscode-lima-0.0.1.pkg
**VS Code Extension Installer**

- Installs vscode-lima and Lima as dependencies
- Provides `vscode-lima-install` command for extension installation
- Taps stuffbucket/tap repository
- **Requires:** Homebrew (checks during installation)

## Building Packages

### Build All Packages
```bash
./build-all.sh
```

### Build Individual Packages
```bash
cd homebrew && ./build.sh
cd lima && ./build.sh
cd vscode-lima && ./build.sh
```

## Installation Order

Install in this order to satisfy dependencies:

1. **stuffbucket-homebrew-1.0.0.pkg** (foundation)
2. **stuffbucket-lima-2.0.0.pkg** (requires Homebrew)
3. **stuffbucket-vscode-lima-0.0.1.pkg** (requires Homebrew)

Note: The Lima and VS Code Lima packages will check for Homebrew and refuse to install if it's not present.

## Package Structure

Each package directory contains:
- `build.sh` - Build script for the package
- `postinstall` - Post-installation script
- `distribution.xml` - Package metadata and dependencies
- `welcome.html` - Pre-installation welcome screen
- `conclusion.html` - Post-installation completion screen
- `build/` - Generated during build (ignored by git)

## Technical Details

### Component Identifiers
- `com.stuffbucket.homebrew`
- `com.stuffbucket.lima`
- `com.stuffbucket.vscode-lima`

### Installation Checks
Lima and VS Code Lima packages include JavaScript installation checks that verify Homebrew is installed before proceeding.

### Postinstall Scripts
All packages use postinstall scripts to:
- Detect system architecture (Intel vs Apple Silicon)
- Configure Homebrew paths appropriately
- Install formulas via `brew install`
- Update shell configurations

## Distribution

These packages can be distributed independently:
- **Homebrew package** can be shared for general Homebrew setup
- **Lima package** can be installed by anyone with Homebrew
- **VS Code Lima package** requires both Homebrew and Lima

## License

See `../LICENSE` for license information (shared with parent repository).
