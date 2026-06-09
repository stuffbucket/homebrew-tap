# typed: false
# frozen_string_literal: true

# Homebrew formula for bladerunner — SOURCE OF TRUTH.
#
# Source-controlled here so formula changes flow through code review. The
# release workflow (.github/workflows/release-please.yml) renders the
# PLACEHOLDER_* tokens from the just-published release and syncs a copy into
# stuffbucket/homebrew-tap (Formula/bladerunner.rb). Do NOT commit real values
# into the PLACEHOLDER_* slots — they are filled per-release by the sync step,
# so a future bump is one workflow run.
#
#   0.4.0              ← the release version, without leading `v`
#   fe127cb6bdd2cd4fb5b998d67a08d8d8dc13bb965e4f7e68bc3e3fe19aeaf91c  ← sha256 of the darwin/aarch64 tarball,
#                                       from the release's checksums.txt
class Bladerunner < Formula
  desc "Standalone Incus VM runner for macOS using Apple Virtualization.framework"
  homepage "https://github.com/stuffbucket/bladerunner"
  version "0.4.0"
  license "MIT"

  # Apple Silicon only. There is no darwin-x64 artifact in the release.
  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/stuffbucket/bladerunner/releases/download/v0.4.0/bladerunner_0.4.0_darwin_aarch64.tar.gz"
      sha256 "fe127cb6bdd2cd4fb5b998d67a08d8d8dc13bb965e4f7e68bc3e3fe19aeaf91c"
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
