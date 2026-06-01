# typed: false
# frozen_string_literal: true

class Bladerunner < Formula
  desc "Standalone Incus VM runner for macOS using Apple Virtualization.framework"
  homepage "https://github.com/stuffbucket/bladerunner"
  url "https://github.com/stuffbucket/bladerunner/releases/download/v0.3.0/bladerunner_0.3.0_darwin_aarch64.tar.gz"
  sha256 "c149456870579488236ae16b47913870fe723b58bbc0c2551229e277b858ed70"
  license "MIT"
  version "0.3.0"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "runner"
  end

  def post_install
    # Codesign with Virtualization.framework entitlements
    entitlements = prefix/"vz.entitlements"
    if entitlements.exist?
      system "codesign", "--force", "--entitlements", entitlements, "-s", "-", bin/"runner"
    end
  end

  def caveats
    <<~EOS
      bladerunner requires Apple Silicon (M1/M2/M3/M4) and macOS 13+.

      The binary has been codesigned with Virtualization.framework entitlements.
      If you need to re-sign manually:
        codesign --entitlements #{prefix}/vz.entitlements -s - #{bin}/runner
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runner --version")
  end
end
