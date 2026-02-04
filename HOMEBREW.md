# Installing Homebrew

[Homebrew](https://brew.sh) is the most popular package manager for macOS, making it easy to install and manage software from the command line.

## Installation

There are three ways to install Homebrew:

- Install Homebrew by [downloading](https://github.com/Homebrew/brew/releases/latest/download) their latest installer (macOS only)
- Go to [their site](https://brew.sh) for instructions
- Use the one-line command below from a terminal window

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The macOS will prompt you for your password and the installer will guide you through the process.

## Configure Your Shell

After installation, ensure Homebrew is in your PATH:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon (M1/M2/M3)
# or
eval "$(/usr/local/bin/brew shellenv)"     # Intel
```

To make this permanent, add the appropriate line to your shell profile:

**zsh (default on macOS):**
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

**bash:**
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
```

## Verify Installation

Check that Homebrew is working:

```bash
brew --version
```

You should see output like: `Homebrew 4.x.x`

## Learn More

- [Homebrew Documentation](https://docs.brew.sh)
- [Homebrew FAQ](https://docs.brew.sh/FAQ)
- [Homebrew GitHub](https://github.com/Homebrew/brew)
