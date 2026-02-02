.PHONY: help list-formulas info audit ci

help:
	@echo "Homebrew Tap Maintenance"
	@echo ""
	@echo "Targets:"
	@echo "  make info           Show current versions of all formulas"
	@echo "  make list-formulas  List all available formulas"
	@echo "  make audit          Run brew audit on all formulas"
	@echo "  make ci             Run CI tests locally with act"
	@echo ""
	@echo "Note: Formulas are automatically updated by their source repository workflows."
	@echo "      See each project's .github/workflows/release.yml for details."

ci:
	@command -v act >/dev/null 2>&1 || { echo "Install act: brew install act"; exit 1; }
	act -j test-formulas

list-formulas:
	@echo "Available formulas:"
	@ls -1 Formula/*.rb 2>/dev/null | xargs -n1 basename | sed 's/\.rb$$//' || echo "No formulas found"

info:
	@echo "Current Formula Versions:"
	@echo "========================="
	@for formula in Formula/*.rb; do \
		if [ -f "$$formula" ]; then \
			name=$$(basename $$formula .rb); \
			version=$$(grep -E '^\s*version\s+"' $$formula | head -1 | sed 's/.*"\(.*\)".*/\1/'); \
			url=$$(grep -E '^\s*url\s+"' $$formula | head -1 | sed 's/.*"\(.*\)".*/\1/'); \
			if [ -z "$$version" ]; then \
				version=$$(echo "$$url" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "unknown"); \
			fi; \
			echo ""; \
			echo "$$name:"; \
			echo "  Version: $$version"; \
			echo "  URL: $$url"; \
		fi; \
	done

audit:
	@echo "Running brew audit on all formulas..."
	@echo "======================================"
	@brew tap stuffbucket/tap $$(pwd) 2>/dev/null || true
	@for formula in Formula/*.rb; do \
		if [ -f "$$formula" ]; then \
			name=$$(basename $$formula .rb); \
			echo ""; \
			echo "Auditing $$name..."; \
			brew audit --strict --online stuffbucket/tap/$$name || echo "⚠️  Audit failed for $$name"; \
		fi; \
	done