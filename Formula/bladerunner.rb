# typed: false
# frozen_string_literal: true

# Homebrew formula for bladerunner — SOURCE OF TRUTH.
#
# Source-controlled so formula changes flow through code review. The release
# workflow (.github/workflows/release-please.yml) fills the version and the
# darwin/arm64 sha256 from the just-published release, then syncs a rendered
# copy into stuffbucket/homebrew-tap (Formula/bladerunner.rb). The two values
# are the only per-release edits, so a bump is one workflow run.
class Bladerunner < Formula
  desc "Standalone Incus VM runner for macOS using Apple Virtualization.framework"
  homepage "https://github.com/stuffbucket/bladerunner"
  version "0.4.8"
  license "MIT"

  # Apple Silicon only. There is no darwin-x64 artifact in the release.
  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/stuffbucket/bladerunner/releases/download/v0.4.8/bladerunner_0.4.8_darwin_aarch64.tar.gz"
      sha256 "50813cd7e325a9d4f5377ef9d021c8c76b8165beca733531daf056e87415c5c4"
    end
  end

  def install
    bin.install "br"
    prefix.install "vz.entitlements"
  end

  def post_install
    # Re-apply the Virtualization.framework entitlement via an ad-hoc signature
    # so `br` can create VMs. The released binary is already ad-hoc signed; this
    # is belt-and-suspenders in case extraction/relocation invalidated it.
    entitlements = prefix/"vz.entitlements"
    system "codesign", "--force", "--entitlements", entitlements, "-s", "-", bin/"br" if entitlements.exist?
  end

  def caveats
    <<~EOS
      bladerunner requires Apple Silicon (M1/M2/M3/M4) and macOS 13+.

      `br` has been ad-hoc codesigned with Virtualization.framework entitlements.
      If you need to re-sign manually:
        codesign --entitlements #{prefix}/vz.entitlements -s - #{bin}/br
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/br --version")
  end
end
