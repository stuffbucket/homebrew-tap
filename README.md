# Stuffbucket Homebrew Tap

Homebrew formulae for stuffbucket projects.

## Installation

### Via Homebrew (Recommended)

```bash
brew tap stuffbucket/tap
brew install stuffbucket/tap/<formula>
```

### Via macOS Installer Packages

Pre-built macOS `.pkg` installers are available in the `pkgs/` directory:

1. **stuffbucket-homebrew-1.pkg** - Installs Homebrew (install first)
2. **stuffbucket-lima-2.pkg** - Installs Lima (requires Homebrew)
3. **stuffbucket-vscode-lima-0.pkg** - Installs VS Code Lima extension (requires Homebrew)

Note: Package filenames use major version only. They install the latest software version from the formulas.

See [pkgs/README.md](pkgs/README.md) for details.

## Available Formulas

### lima
Linux virtual machines with GUI desktop support via VZ.

**Repository:** [stuffbucket/lima](https://github.com/stuffbucket/lima)

### qemu-spice
QEMU with SPICE protocol support and Apple Silicon optimizations.

**Repository:** [QEMU Project](https://www.qemu.org/) (formula based on [stuffbucket/homebrew-qemu-spice](https://github.com/stuffbucket/homebrew-qemu-spice))

### virglrenderer
Virtual GPU renderer for QEMU (macOS port).

**Repository:** [akihikodaki/virglrenderer](https://github.com/akihikodaki/virglrenderer) (macOS branch)

### libepoxy-egl
OpenGL function pointer library with EGL support for macOS.

**Repository:** [anholt/libepoxy](https://github.com/anholt/libepoxy)

### vscode-lima
VS Code extension installer for Lima Manager.

**Repository:** [stuffbucket/vscode-lima](https://github.com/stuffbucket/vscode-lima)

## License

MIT