# frozen_string_literal: true

# Homebrew formula for gliner-runner release candidates (self-contained ONNX runtime, no Python).
#
# This is the template; the rendered copy is attached to every release candidate (GitHub
# prerelease) as `gliner-runner-rc.rb` and synced into stuffbucket/homebrew-tap. Placeholder tokens
# are replaced from the release's archive digests by scripts/render-homebrew-formula.mjs. Do not
# commit real versions or digests to this template.

class GlinerRunnerRc < Formula
  desc "GLiNER2 inference runner, release candidate for testing (ONNX, no Python)"
  homepage "https://github.com/stuffbucket/gliner-runner"
  license "Apache-2.0"

  # Prereleases are not served as the latest release and livecheck's GitHub strategies skip them, so
  # read the vX.Y.Z-rc.N tags from git.
  livecheck do
    url :homepage
    regex(/^v?(\d+\.\d+\.\d+-rc\.\d+)$/i)
    strategy :git
  end

  on_macos do
    on_arm do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.0-rc.2/gliner-runner-onnx-0.3.0-rc.2-darwin-arm64.tar.gz"
      sha256 "d89a206231eb3e5812c8d86854c19702ee45f63f9f137ecdbb5892dbd2cbaaa7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.0-rc.2/gliner-runner-onnx-0.3.0-rc.2-linux-x64.tar.gz"
      sha256 "4e3269a473b5c1adcdbb28aea19a5a1d2945d3deff4f172daaca8b34b62add01"
    end
    on_arm do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.3.0-rc.2/gliner-runner-onnx-0.3.0-rc.2-linux-arm64.tar.gz"
      sha256 "a25789264d64229a6af8337298206565128495015d0601acc4e76b6f0fc71efd"
    end
  end

  conflicts_with "gliner-runner", because: "both install a `gliner-runner` executable"

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
