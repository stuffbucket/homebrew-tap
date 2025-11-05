.PHONY: help update check-tag list-formulas update-all info dry-run

FORMULA ?=

help:
	@echo "Homebrew Tap Maintenance"
	@echo ""
	@echo "Usage:"
	@echo "  make info                Show current formula versions"
	@echo "  make dry-run             Show what update commands would be needed"
	@echo "  make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"
	@echo "  make list-formulas"
	@echo ""
	@echo "Targets:"
	@echo "  info           Show current versions of all formulas"
	@echo "  dry-run        Show update commands for all formulas (manual step)"
	@echo "  update         Update formula with new release tag"
	@echo "                 Requires FORMULA and TAG parameters"
	@echo "  list-formulas  List all available formulas"
	@echo ""
	@echo "Examples:"
	@echo "  make info"
	@echo "  make dry-run"
	@echo "  make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"

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
