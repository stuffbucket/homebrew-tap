# Stuffbucket Homebrew Tap

Homebrew formulae for stuffbucket projects.

## Installation

### Quick Install (Recommended)

One command installs everything:

```bash
curl -fsSL https://raw.githubusercontent.com/stuffbucket/homebrew-tap/main/install.sh | bash
```

This installs:
- Homebrew (if not already installed)
- Lima
- VS Code Lima Manager extension (from marketplace)

### Via Homebrew

```bash
# Install Lima
brew tap stuffbucket/tap
brew install stuffbucket/tap/lima

# Install VS Code extension
code --install-extension stuffbucket-co.lima-manager
```

Or install the extension in VS Code:
- Press `Cmd+Shift+X` (Extensions)
- Search for "Lima Manager"
- Click Install

### Via macOS Installer Packages

Pre-built macOS `.pkg` installers are available in the `pkgs/` directory:

1. **stuffbucket-homebrew-1.pkg** - Installs Homebrew (install first)
2. **stuffbucket-lima-2.pkg** - Installs Lima (requires Homebrew)

Then install the VS Code extension:
```bash
code --install-extension stuffbucket-co.lima-manager
```

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

## VS Code Extension

The **Lima Manager** VS Code extension is available on the marketplace:

**Marketplace:** [stuffbucket-co.lima-manager](https://marketplace.visualstudio.com/items?itemName=stuffbucket-co.lima-manager)
**Repository:** [stuffbucket/vscode-lima](https://github.com/stuffbucket/vscode-lima)

Install with: `code --install-extension stuffbucket-co.lima-manager`

The extension auto-updates through VS Code.

## License

MIT