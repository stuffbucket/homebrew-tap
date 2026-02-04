.PHONY: help list-formulas info audit ci shellcheck lint test test-installers

help:
	@echo "Homebrew Tap Maintenance"
	@echo ""
	@echo "Targets:"
	@echo "  make info            Show current versions of all formulas"
	@echo "  make list-formulas   List all available formulas"
	@echo "  make audit           Run brew audit on all formulas"
	@echo "  make shellcheck      Run shellcheck on all installer scripts"
	@echo "  make test-installers Run tests on installer scripts"
	@echo "  make lint            Run all linting (shellcheck + validators)"
	@echo "  make test            Run all tests (lint + installer tests)"
	@echo "  make ci              Run CI tests locally with act"
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

shellcheck:
	@echo "Running shellcheck on installer scripts..."
	@echo "==========================================="
	@command -v shellcheck >/dev/null 2>&1 || { echo "❌ shellcheck not found. Install: brew install shellcheck"; exit 1; }
	@for script in install/*; do \
		if [ -f "$$script" ]; then \
			echo ""; \
			echo "Checking $$(basename $$script)..."; \
			shellcheck "$$script" && echo "✓ No issues found"; \
		fi; \
	done

test-installers:
	@echo "Running installer tests..."
	@echo "=========================="
	@for script in install/*; do \
		if [ -f "$$script" ]; then \
			name=$$(basename $$script); \
			echo ""; \
			echo "Testing $$name:"; \
			echo "  - Bash syntax..."; \
			bash -n "$$script" && echo "    ✓ Valid" || { echo "    ❌ Invalid syntax"; exit 1; }; \
			echo "  - Executable bit..."; \
			[ -x "$$script" ] && echo "    ✓ Set" || { echo "    ❌ Missing"; exit 1; }; \
			echo "  - Line length..."; \
			long_lines=$$(awk 'length > 120 {count++} END {print count+0}' "$$script"); \
			[ "$$long_lines" -eq 0 ] && echo "    ✓ All lines ≤120 chars" || echo "    ⚠ $$long_lines lines exceed 120 chars"; \
			echo "  - Security scan..."; \
			grep -iq 'password\|secret\|token\|api[_-]key' "$$script" && { echo "    ❌ Potential hardcoded secrets found"; exit 1; } || echo "    ✓ No hardcoded secrets"; \
		fi; \
	done
	@echo ""
	@echo "✓ All installer tests passed"

lint: shellcheck
	@echo ""
	@echo "✓ All linting passed"

test: lint test-installers
	@echo ""
	@echo "✓ All tests passed"
