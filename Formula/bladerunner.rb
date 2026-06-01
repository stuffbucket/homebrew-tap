# typed: false
# frozen_string_literal: true

class Bladerunner < Formula
  desc "Standalone Incus VM runner for macOS using Apple Virtualization.framework"
  homepage "https://github.com/stuffbucket/bladerunner"
  url "https://github.com/stuffbucket/bladerunner/releases/download/v0.2.0/bladerunner_0.2.0_darwin_aarch64.tar.gz"
  sha256 "34bb7a22cca2938d126920d096e56a6947e403123d51264aa062f311e258888c"
  license "MIT"
  version "0.2.0"

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
