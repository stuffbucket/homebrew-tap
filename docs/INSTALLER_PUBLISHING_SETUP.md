# Setting Up Automated Installer Publishing

This guide explains how to set up the `stuffbucket/installers` repository for automated package publishing.

## 1. Create the Installers Repository

```bash
# Create a new repository on GitHub
# Name: installers
# Owner: stuffbucket
# Description: Pre-built installer packages
# Public/Private: Your choice
```

## 2. Initialize the Repository

```bash
# Clone the new repo
git clone git@github.com:stuffbucket/installers.git
cd installers

# Create initial structure
mkdir -p macos
cat > README.md <<'EOF'
[paste contents from docs/INSTALLERS_REPO_README.md]
EOF

# Create .gitattributes for LFS (optional, for tracking .pkg files)
cat > .gitattributes <<'EOF'
*.pkg filter=lfs diff=lfs merge=lfs -text
EOF

# Initial commit
git add .
git commit -m "Initial commit"
git push origin main
```

## 3. Create Personal Access Token (PAT)

1. Go to https://github.com/settings/tokens?type=beta
2. Click "Generate new token"
3. Configure:
   - **Token name:** `homebrew-tap-to-installers`
   - **Expiration:** Your preference (recommend 1 year)
   - **Repository access:** Only select repositories → Choose `stuffbucket/installers`
   - **Repository permissions:**
     - Contents: Read and write
     - Metadata: Read-only (automatically selected)
4. Click "Generate token" and copy it immediately (you won't see it again)

## 4. Add Secret to homebrew-tap Repository

1. Go to `stuffbucket/homebrew-tap` → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add:
   - **Name:** `INSTALLERS_PAT`
   - **Value:** [paste the PAT from step 3]
4. Click "Add secret"

## 5. Test the Workflow

### Option A: Manual Trigger
1. Go to homebrew-tap → Actions → "Publish Installers"
2. Click "Run workflow" → "Run workflow"
3. Watch the workflow execute

### Option B: Push a Change
1. Make any change to a formula or the pkgs/ directory
2. Commit and push to main
3. Workflow will trigger automatically

## 6. Verify Publication

After successful workflow run:
1. Check `stuffbucket/installers` repo for new commit
2. Check Releases tab for new release with attached .pkg files
3. Verify `SHA256SUMS` and `versions.json` are present

## Workflow Behavior

- **Trigger:** Any push to main that affects formulas or packages
- **Actions:**
  1. Syncs package versions from formulas
  2. Builds all .pkg files
  3. Copies to installers repo
  4. Generates checksums and version manifest
  5. Creates git tag (e.g., `lima-v2.0.0-beta.0.1`)
  6. Creates GitHub release with all packages attached

## Troubleshooting

### "Resource not accessible by integration"
- PAT permissions insufficient
- Regenerate PAT with correct permissions

### "Repository not found"
- Ensure `stuffbucket/installers` exists and is accessible
- Check PAT has access to the repository

### Packages not building
- Check brew formulas are valid
- Run `make pkg-check-versions` locally first

## Optional: Git LFS for Package Files

If you want to track .pkg files with Git LFS (recommended for better storage):

```bash
cd installers
git lfs install
git lfs track "*.pkg"
git add .gitattributes
git commit -m "Track .pkg files with Git LFS"
git push
```

Update workflow to use LFS:
```yaml
- name: Checkout installers repo
  uses: actions/checkout@v4
  with:
    repository: stuffbucket/installers
    token: ${{ secrets.INSTALLERS_PAT }}
    path: installers
    lfs: true  # Add this line
```

## Manual Release Process

If you need to manually release without the workflow:

```bash
cd /path/to/homebrew-tap
make pkg-sync-versions
make pkg-build

cd /path/to/installers
cp ../homebrew-tap/pkgs/*/stuffbucket-*.pkg macos/
cd macos
shasum -a 256 *.pkg > SHA256SUMS
git add .
git commit -m "Manual update"
git push
```
