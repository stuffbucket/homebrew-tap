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
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.1/gliner-runner-onnx-0.3.1-darwin-arm64.tar.gz"
      sha256 "b3d6d1779323bd807794e7d53e9a81193e21137f8e6a461c8ef58fa91f94fbd8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.1/gliner-runner-onnx-0.3.1-linux-x64.tar.gz"
      sha256 "cd0c4a783e8ac12a353a9aa8fcad5e90387246f447f802fbc34edcb3e1a22be2"
    end
    on_arm do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.1/gliner-runner-onnx-0.3.1-linux-arm64.tar.gz"
      sha256 "6f7e053727d64de327c6132240b9d76e913007ba806bc93f411581cd478b9c42"
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
