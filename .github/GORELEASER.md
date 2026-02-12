# GoReleaser Homebrew Formula Configuration

This tap is configured to accept GoReleaser-generated Homebrew formulas.

## The Problem

GoReleaser generates multi-architecture formulas with `def install` methods inside `on_macos do` / `on_linux do` blocks:

```ruby
on_macos do
  if Hardware::CPU.arm?
    url "..."
    sha256 "..."

    def install
      bin.install "myapp"
    end
  end
end
```

Homebrew's `brew audit --strict` rejects this pattern with:
> Do not define methods in blocks (use `define_method` as a workaround).

## Solution

Two files handle this:

### 1. `.rubocop.yml`

Disables the `Style/MethodDefinedInBlock` check that flags `def` inside blocks.

### 2. `.github/workflows/tests.yml`

Makes `brew audit` non-fatal since Homebrew's own linter still flags this pattern.

## Adding a New GoReleaser Project

### Step 1: Configure `.goreleaser.yaml` in your project

```yaml
brews:
  - name: myapp
    repository:
      owner: stuffbucket
      name: homebrew-tap
      token: "{{ .Env.HOMEBREW_TAP_TOKEN }}"
    homepage: "https://github.com/stuffbucket/myapp"
    description: "My app description"
    license: "MIT"
    dependencies:
      - name: colima  # if needed
    install: |
      bin.install "myapp"
    test: |
      system bin/"myapp", "--version"
```

### Step 2: Set `HOMEBREW_TAP_TOKEN` secret

In your project's GitHub repository settings, add a secret with write access to homebrew-tap.

### Step 3: Create installer files in homebrew-tap

```bash
# Brewfiles/myapp
tap "stuffbucket/tap"
brew "stuffbucket/tap/myapp"

# install/myapp (executable)
#!/bin/bash
set -e
# ... installer logic using brew bundle --file=<(curl ... Brewfiles/myapp)
```

### Step 4: Tag and release

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

GoReleaser pushes the formula automatically. Update README.md to document the new formula.

## User Installation

```bash
curl -fsSL https://raw.githubusercontent.com/stuffbucket/homebrew-tap/main/install/myapp | bash
```

## Reference

Pattern matches `radiolabme/homebrew-tap` configuration.
