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
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.0/gliner-runner-onnx-0.3.0-darwin-arm64.tar.gz"
      sha256 "d1924b797071e2ec57ad5f140b76c3411267efbe4ee29a8fa7637a10a36f7e6d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.0/gliner-runner-onnx-0.3.0-linux-x64.tar.gz"
      sha256 "eb222b5eabbc88cd430c628ab6a6c864951193f288e64769d0a9fc39a0bf70a0"
    end
    on_arm do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.0/gliner-runner-onnx-0.3.0-linux-arm64.tar.gz"
      sha256 "cc166bfdd0ad802a3e8e1e7f79138664ef8b06a772c929e000a2eb5cfeb477bc"
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
