.PHONY: help update check-tag list-formulas update-all info dry-run pkg-sync-versions pkg-check-versions pkg-check-stale pkg-build

FORMULA ?=

help:
	@echo "Homebrew Tap Maintenance"
	@echo ""
	@echo "Usage:"
	@echo "  make info                Show current formula versions"
	@echo "  make dry-run             Show what update commands would be needed"
	@echo "  make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"
	@echo "  make list-formulas"
	@echo "  make pkg-check-versions  Check if package versions match formula versions"
	@echo "  make pkg-check-stale     Check if packages need rebuilding (commit hash changed)"
	@echo "  make pkg-sync-versions   Update package versions to match formulas"
	@echo "  make pkg-build           Build all macOS installer packages"
	@echo ""
	@echo "Targets:"
	@echo "  info                Show current versions of all formulas"
	@echo "  dry-run             Show update commands for all formulas (manual step)"
	@echo "  update              Update formula with new release tag"
	@echo "                      Requires FORMULA and TAG parameters"
	@echo "  list-formulas       List all available formulas"
	@echo "  pkg-check-versions  Check package vs formula version mismatches"
	@echo "  pkg-check-stale     Check if packages were built from current commit"
	@echo "  pkg-sync-versions   Sync package versions to match formula versions"
	@echo "  pkg-build           Build all macOS .pkg installer packages"
	@echo ""
	@echo "Examples:"
	@echo "  make info"
	@echo "  make dry-run"
	@echo "  make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"
	@echo "  make pkg-check-versions"
	@echo "  make pkg-check-stale"
	@echo "  make pkg-sync-versions"
	@echo "  make pkg-build"

list-formulas:
	@echo "Available formulas:"
	@ls -1 Formula/*.rb | xargs -n1 basename | sed 's/\.rb$$//'

info:
	@echo "Current Formula Versions:"
	@echo "========================="
	@for formula in Formula/*.rb; do \
		name=$$(basename $$formula .rb); \
		version=$$(grep -E '^\s*version\s+"' $$formula | head -1 | sed 's/.*"\(.*\)".*/\1/'); \
		url=$$(grep -E '^\s*url\s+"' $$formula | head -1 | sed 's/.*"\(.*\)".*/\1/'); \
		if [ -z "$$version" ]; then \
			version=$$(echo "$$url" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1); \
		fi; \
		echo ""; \
		echo "$$name:"; \
		echo "  Version: $$version"; \
		echo "  URL: $$url"; \
	done

dry-run:
	@echo "Formula Update Commands:"
	@echo "========================"
	@echo ""
	@echo "For stuffbucket-maintained formulas, check GitHub releases and run:"
	@echo ""
	@for formula in Formula/lima.rb; do \
		if [ -f "$$formula" ]; then \
			name=$$(basename $$formula .rb); \
			version=$$(grep -E '^\s*version\s+"' $$formula | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo "current"); \
			echo "# $$name (current: $$version)"; \
			echo "# Check: https://github.com/stuffbucket/$$name/releases"; \
			echo "make update FORMULA=$$name TAG=vNEW_VERSION-fork"; \
			echo ""; \
		fi; \
	done
	@echo "For upstream formulas (qemu-spice, virglrenderer, libepoxy-egl):"
	@echo "These track upstream projects and typically don't need frequent updates."
	@echo "Update manually if new versions are released:"
	@echo ""
	@for formula in Formula/qemu-spice.rb Formula/virglrenderer.rb Formula/libepoxy-egl.rb; do \
		if [ -f "$$formula" ]; then \
			name=$$(basename $$formula .rb); \
			version=$$(grep -E '^\s*version\s+"' $$formula | head -1 | sed 's/.*"\(.*\)".*/\1/'); \
			url=$$(grep -E '^\s*url\s+"' $$formula | head -1 | sed 's/.*"\(.*\)".*/\1/'); \
			if [ -z "$$version" ]; then \
				version=$$(echo "$$url" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1); \
			fi; \
			echo "# $$name (current: $$version)"; \
			echo "# URL: $$url"; \
			echo "# Manual update required - edit Formula/$$name.rb directly"; \
			echo ""; \
		fi; \
	done

update-all:
	@echo "Note: update-all is not automated. Use 'make dry-run' to see update commands."
	@echo ""
	@make dry-run

check-tag:
	@if [ -z "$(FORMULA)" ]; then \
		echo "Error: FORMULA parameter is required"; \
		echo "Usage: make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"; \
		exit 1; \
	fi
	@if [ -z "$(TAG)" ]; then \
		echo "Error: TAG parameter is required"; \
		echo "Usage: make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"; \
		exit 1; \
	fi
	@if [ ! -f "Formula/$(FORMULA).rb" ]; then \
		echo "Error: Formula '$(FORMULA)' not found in Formula/ directory"; \
		echo "Available formulas:"; \
		make list-formulas; \
		exit 1; \
	fi

update: check-tag
	@echo "Updating $(FORMULA) formula to $(TAG)..."
	@# Extract version from tag (strip 'v' prefix and '-fork' suffix)
	$(eval VERSION := $(shell echo $(TAG) | sed 's/^v//' | sed 's/-fork$$//'))
	@echo "Version: $(VERSION)"
	@# Download tarball and calculate SHA256
	@echo "Calculating SHA256 checksum..."
	$(eval SHA256 := $(shell curl -sL https://github.com/stuffbucket/$(FORMULA)/archive/refs/tags/$(TAG).tar.gz | shasum -a 256 | cut -d' ' -f1))
	@echo "SHA256: $(SHA256)"
	@# Update the formula
	@sed -i '' 's|url "https://github.com/stuffbucket/$(FORMULA)/archive/refs/tags/v.*\.tar\.gz"|url "https://github.com/stuffbucket/$(FORMULA)/archive/refs/tags/$(TAG).tar.gz"|' Formula/$(FORMULA).rb
	@sed -i '' 's|version ".*"|version "$(VERSION)"|' Formula/$(FORMULA).rb
	@sed -i '' 's|sha256 ".*"|sha256 "$(SHA256)"|' Formula/$(FORMULA).rb
	@echo "Formula updated successfully"
	@echo ""
	@echo "Changes:"
	@git diff Formula/$(FORMULA).rb
	@echo ""
	@read -p "Commit and push changes? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		git add Formula/$(FORMULA).rb && \
		git commit -m "Update $(FORMULA) to $(TAG)" && \
		git push && \
		echo "Changes pushed to remote"; \
	else \
		echo "Changes not committed. Review with 'git diff'"; \
	fi

pkg-check-versions:
	@echo "Current Versions (from brew):"
	@echo "============================="
	@echo ""
	@brew tap stuffbucket/tap $$(pwd) 2>/dev/null || true
	@echo "lima:"
	@brew info --json=v2 stuffbucket/tap/lima | jq -r '.formulae[0].versions.stable' | sed 's/^/  Version: /'
	@echo ""
	@echo "vscode-lima:"
	@brew info --json=v2 stuffbucket/tap/vscode-lima | jq -r '.formulae[0].versions.stable' | sed 's/^/  Version: /'
	@echo ""
	@echo "Note: Build scripts query brew dynamically at build time."
	@echo "Note: stuffbucket-homebrew package is tap-only (version 1.0.0 is static)"

pkg-sync-versions:
	@echo "Version sync is no longer needed."
	@echo "Build scripts query brew dynamically at build time."
	@echo ""
	@echo "To see current versions, run: make pkg-check-versions"

pkg-check-stale:
	@echo "Checking if packages are stale..."
	@CURRENT_HASH=$$(git rev-parse HEAD 2>/dev/null || echo "unknown"); \
	for metadata in pkgs/*/.build-metadata; do \
		if [ -f "$$metadata" ]; then \
			PKG_DIR=$$(dirname "$$metadata"); \
			PKG_NAME=$$(basename "$$PKG_DIR"); \
			BUILD_HASH=$$(grep '^GIT_HASH=' "$$metadata" | cut -d'=' -f2); \
			BUILD_DATE=$$(grep '^BUILD_DATE=' "$$metadata" | cut -d'=' -f2); \
			if [ "$$BUILD_HASH" != "$$CURRENT_HASH" ]; then \
				echo "⚠️  $$PKG_NAME package is STALE"; \
				echo "    Built from: $$BUILD_HASH"; \
				echo "    Current:    $$CURRENT_HASH"; \
				echo "    Built on:   $$BUILD_DATE"; \
				echo ""; \
			else \
				echo "✅ $$PKG_NAME package is up-to-date"; \
			fi; \
		fi; \
	done

pkg-build:
	@echo "Building macOS installer packages..."
	@cd pkgs && ./build-all.sh
	@echo ""
	@echo "✓ All packages built successfully"
	@echo ""
	@find pkgs -name "*.pkg" -not -path "*/build/*" -exec ls -lh {} \;