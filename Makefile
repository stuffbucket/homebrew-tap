.PHONY: help update check-tag list-formulas

FORMULA ?=

help:
	@echo "Homebrew Tap Maintenance"
	@echo ""
	@echo "Usage:"
	@echo "  make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"
	@echo "  make list-formulas"
	@echo ""
	@echo "Targets:"
	@echo "  update         Update formula with new release tag"
	@echo "                 Requires FORMULA and TAG parameters"
	@echo "  list-formulas  List all available formulas"
	@echo ""
	@echo "Examples:"
	@echo "  make update FORMULA=lima TAG=v2.0.0-beta.0.2-fork"

list-formulas:
	@echo "Available formulas:"
	@ls -1 Formula/*.rb | xargs -n1 basename | sed 's/\.rb$$//'

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
