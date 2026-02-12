# bladerunner

Bladerunner is a purpose-built runner for Incus system container runtime and management. 

There are many solutions (lima-vm, colima, etc.) that can support managing an Incus runtime VM.
However, they do not specialize running Incus server and often can be harder to manage and setup
as a result. Bladerunner was created to do one thing, and one thing only: provide a place to
run Incus system containers on macOS. Reducing the the number of dependencies and moving parts
that need to be installed and managed means Incus system containers are simpler to use.

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
curl -fsSL https://raw.githubusercontent.com/stuffbucket/homebrew-tap/main/install/bladerunner | bash && eval "$(brew shellenv)"
```

This one-liner installs coop and configures your environment for immediate use.

## What the Installer Does

| Step | Action | Details |
|------|--------|---------|
| 1️⃣ Check prerequisites | Verifies macOS and Homebrew | Provides install instructions if Homebrew is missing |
| 3️⃣ Install bladerunner | Installs the **br** binary | Core tool for incus management |
| 4️⃣ Configure PATH | Sets up shell environment | Makes `br` command immediately available |

After installation completes, commands are available in your current shell—no restart required.

## Quick Start

Start the bladerunner VM runtime:

```bash
br start
```

Run br:

```bash
br --help
```

## Dependencies

- **[vz](https://github.com/code-hex/vz)** — Apple VZ framework for macOS VM runtime


This is included in the bladerunner executable itself. Third-party notices and attributions
are available via the NOTICES file in the bladerunner repository and through the `br notice` command.

## Manual Installation

If you prefer to install without the automated script:

```bash
brew install stuffbucket/tap/bladerunner
```

Then configure your PATH:

```bash
eval "$(brew shellenv)"
```

## Links

- **Repository:** [stuffbucket/bladerunner](https://github.com/stuffbucket/bladerunner)
- **Issues:** [Report a bug](https://github.com/stuffbucket/bladerunner/issues)
- **License:** MIT
---

<p align="center">
  <a href="https://github.com/stuffbucket/coop">Repository</a> •
  <a href="https://github.com/stuffbucket/coop/issues">Report a Bug</a> •
  <a href="https://github.com/stuffbucket/coop/blob/main/LICENSE">License: MIT</a>
</p>