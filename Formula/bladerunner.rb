# typed: false
# frozen_string_literal: true

class Bladerunner < Formula
  desc "Standalone Incus VM runner for macOS using Apple Virtualization.framework"
  homepage "https://github.com/stuffbucket/bladerunner"
  url "https://github.com/stuffbucket/bladerunner/releases/download/v0.1.3/bladerunner_0.1.3_darwin_aarch64.tar.gz"
  sha256 "ad6be88fd695d806ab594ce9618a26ff8f225e15838c2ce4fb1aff6c1df9eff0"
  license "MIT"
  version "0.1.3"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "br"
  end

  def post_install
    # Codesign with Virtualization.framework entitlements
    entitlements = prefix/"vz.entitlements"
    if entitlements.exist?
      system "codesign", "--force", "--entitlements", entitlements, "-s", "-", bin/"br"
    end
  end

  def caveats
    <<~EOS
      bladerunner requires Apple Silicon (M1/M2/M3/M4) and macOS 13+.

      The binary has been codesigned with Virtualization.framework entitlements.
      If you need to re-sign manually:
        codesign --entitlements #{prefix}/vz.entitlements -s - #{bin}/br
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/br --version")
  end
end
