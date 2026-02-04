# coop

Container-based execution environment for AI agents with security sandboxing and resource isolation.

Coop provides isolated, containerized workspaces for AI agents to execute code safely. Built on Linux Foundation projects colima and lima-vm, it ensures agent actions are sandboxed from your host system while maintaining easy file sharing and network access controls.

<table style="width: 100%; border: none; background-color: #f6f8fa; margin: 20px 0;">
  <tr>
    <td style="padding: 12px 16px; border: none; text-align: center; font-weight: 500; color: #57606a;">
      Platform: macOS only (for now)
    </td>
  </tr>
</table>

## Prerequisites

**Homebrew required.** If you don't have it installed, see [HOMEBREW.md](../HOMEBREW.md).

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/stuffbucket/homebrew-tap/main/install/coop | bash && eval "$(brew shellenv)"
```

This one-liner installs coop and configures your environment for immediate use.

## What the Installer Does

| Step | Action | Details |
|------|--------|---------|
| 1️⃣ Check prerequisites | Verifies macOS and Homebrew | Provides install instructions if Homebrew is missing |
| 2️⃣ Install dependencies | Installs colima and lima | Container runtime and VM framework |
| 3️⃣ Install coop | Installs the coop binary | Core tool for agent management |
| 4️⃣ Configure PATH | Sets up shell environment | Makes `coop`, `colima`, and `limactl` immediately available |

After installation completes, commands are available in your current shell—no restart required.

## Quick Start

Start the container runtime:

```bash
colima start
```

Run coop:

```bash
coop --help
```

## Dependencies

- **[colima](https://github.com/abiosoft/colima)** — Container runtime for macOS
- **[lima](https://github.com/lima-vm/lima)** — Lightweight Linux VM framework

These are automatically installed by the coop installer.

## Manual Installation

If you prefer to install without the automated script:

```bash
brew install stuffbucket/tap/coop
```

Then configure your PATH:

```bash
eval "$(brew shellenv)"
```

## Links

- **Repository:** [stuffbucket/coop](https://github.com/stuffbucket/coop)
- **Issues:** [Report a bug](https://github.com/stuffbucket/coop/issues)
- **License:** MIT
---

<p align="center">
  <a href="https://github.com/stuffbucket/coop">Repository</a> •
  <a href="https://github.com/stuffbucket/coop/issues">Report a Bug</a> •
  <a href="https://github.com/stuffbucket/coop/blob/main/LICENSE">License: MIT</a>
</p>