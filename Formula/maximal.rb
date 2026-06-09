# frozen_string_literal: true

# Homebrew formula for maximal.
#
# Source-controlled here so changes flow through code review; the
# tap repo (stuffbucket/homebrew-tap) receives a copy via
# `bun scripts/sync-homebrew-formula.ts` after each release.
#
# The placeholder SHAs below (PLACEHOLDER_SHA256_*) are written by
# scripts/sync-homebrew-formula.ts from the per-arch
# maximal-v<version>-<arch>.tar.gz.sha256 files attached to a
# GitHub release. Do not commit real SHAs to this template — the
# sync script writes them into the tap-repo copy and leaves this
# file's placeholders intact so a future bump is one script run.

class Maximal < Formula
  desc "Local proxy that exposes GitHub Copilot as the Anthropic / OpenAI API"
  homepage "https://github.com/stuffbucket/maximal"
  version "0.4.19"
  license "MIT"

  # Apple Silicon only. Intel Macs are not a supported target —
  # there's no darwin-x64 artifact in the release.
  depends_on arch: :arm64
  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/stuffbucket/maximal/releases/download/v#{version}/maximal-v#{version}-darwin-arm64.tar.gz"
      sha256 "f666a405ffe0c62b6e47964f75d21820deb33917f7b34a446a12463b243566f6"
    end
  end

  def install
    bin.install "maximal"
  end

  service do
    run [opt_bin/"maximal", "start"]
    keep_alive true
    log_path var/"log/maximal.log"
    error_log_path var/"log/maximal.err.log"
    environment_variables HOME:           Dir.home,
                          OLLAMA_API_KEY: ENV.fetch("OLLAMA_API_KEY", "")
  end

  test do
    # `debug --json` is the cheapest way to confirm the binary boots
    # and renders structured output. We don't assert keys here — the
    # release pipeline's smoke job (A6) covers schema.
    output = shell_output("#{bin}/maximal debug --json")
    assert_match "\"version\":", output
    assert_match "\"git\":",     output
  end
end
