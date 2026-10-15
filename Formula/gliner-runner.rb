# frozen_string_literal: true

# Homebrew formula for gliner-runner (stable channel; self-contained ONNX runtime, no Python).
#
# This is the template; the rendered copy is attached to every stable GitHub release as
# `gliner-runner.rb` and synced into stuffbucket/homebrew-tap. Placeholder tokens are replaced from
# the release's archive digests by scripts/render-homebrew-formula.mjs. Do not commit real
# versions or digests to this template.

class GlinerRunner < Formula
  desc "Local GLiNER2 inference runner (self-contained ONNX runtime, no Python)"
  homepage "https://github.com/stuffbucket/gliner-runner"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.4.0/gliner-runner-onnx-0.4.0-darwin-arm64.tar.gz"
      sha256 "79771bc34e20d5561f6a97f8e199a42de0496d1ab4c7f8cb70962ab3cb1e3ce6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.4.0/gliner-runner-onnx-0.4.0-linux-x64.tar.gz"
      sha256 "1835684c3a2e1e2168d21cf83d33a071945589e6cbc571a226c3d261c08604fe"
    end
    on_arm do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.4.0/gliner-runner-onnx-0.4.0-linux-arm64.tar.gz"
      sha256 "608d7708c6f794979e245ec895a7c80397b66da309dd37aeb1f854236ddeeac2"
    end
  end

  conflicts_with "gliner-runner-rc", because: "both install a `gliner-runner` executable"

  def install
    # The archive bundles its own Node.js and ONNX Runtime. The launcher resolves symlinks to find
    # its root, so link it rather than wrapping it. Models are not bundled; install them with
    # `gliner-runner models install <id> --yes`.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/gliner-runner"
    bin.install_symlink libexec/"bin/gliner-runner-onnx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gliner-runner --version")
  end
end
