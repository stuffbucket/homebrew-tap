# Stuffbucket Homebrew Tap

Homebrew formulae for stuffbucket projects.

## Installation

```bash
brew tap stuffbucket/tap
brew install stuffbucket/tap/coop
```

## Available Formulas

### coop

AI agent container management with security sandboxing.

**Repository:** [stuffbucket/coop](https://github.com/stuffbucket/coop)

**Installation:**
```bash
brew install stuffbucket/tap/coop
```

**Usage:**
```bash
coop --help
```

## Development

### Install Git Hooks

To run CI tests before pushing:

```bash
ln -sf ../../.github/hooks/pre-push .git/hooks/pre-push
```

### Maintenance

Formulas are automatically updated by their source repository release workflows using GoReleaser.

See the [Makefile](Makefile) for maintenance commands:
- `make info` - Show current formula versions
- `make list-formulas` - List all available formulas
- `make audit` - Run brew audit on all formulas
- `make ci` - Run CI tests locally with act

## License

MIT