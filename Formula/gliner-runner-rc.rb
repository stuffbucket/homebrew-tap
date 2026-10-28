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
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.5.0-rc.1/gliner-runner-onnx-0.5.0-rc.1-darwin-arm64.tar.gz"
      sha256 "a77ab89acfa5d1d1fdaa06ec344719b112e9af2cb1bea7311c6ff9d286d9950e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.5.0-rc.1/gliner-runner-onnx-0.5.0-rc.1-linux-x64.tar.gz"
      sha256 "49607e83c7b04a3de19fd45fff4b94fbf41201b7108ae7b2b9b01b8c394809b0"
    end
    on_arm do
      url "https://github.com/stuffbucket/gliner-runner/releases/download/v0.5.0-rc.1/gliner-runner-onnx-0.5.0-rc.1-linux-arm64.tar.gz"
      sha256 "b5940f4c63d6664ba5c8fee0ff4339b9dfc38f503da777bfe67acfb2aeda37c4"
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
