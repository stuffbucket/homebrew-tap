class VscodeLima < Formula
  desc "VS Code extension for managing Lima virtual machines"
  homepage "https://github.com/stuffbucket/vscode-lima"
  url "https://github.com/stuffbucket/vscode-lima/releases/download/v0.0.1/lima-manager-0.0.1.vsix"
  sha256 "cc11d415d9326ccc4e749aed6d2d8f12a28e53d001938f6b4cf2c47a2422dad0"
  license "MIT"

  depends_on "lima"

  def install
    libexec.install "lima-manager-0.0.1.vsix"

    (bin/"vscode-lima-install").write <<~EOS
      #!/bin/bash
      set -e

      # Find VS Code binary
      VSCODE_BIN=""
      if command -v code &> /dev/null; then
        VSCODE_BIN="code"
      elif command -v code-insiders &> /dev/null; then
        VSCODE_BIN="code-insiders"
      elif [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
        VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
      elif [ -x "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders" ]; then
        VSCODE_BIN="/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders"
      fi

      if [ -z "$VSCODE_BIN" ]; then
        echo "Error: VS Code not found. Please install VS Code or add 'code' to your PATH."
        echo "Download from: https://code.visualstudio.com/"
        exit 1
      fi

      echo "Installing Lima Manager extension..."
      "$VSCODE_BIN" --install-extension "#{libexec}/lima-manager-#{version}.vsix"
      echo "Lima Manager extension installed successfully!"
    EOS

    chmod 0755, bin/"vscode-lima-install"
  end

  def caveats
    <<~EOS
      To install the Lima Manager extension in VS Code, run:
        vscode-lima-install

      Or manually install with:
        code --install-extension #{libexec}/lima-manager-#{version}.vsix

      The extension will be available in VS Code after installation.
    EOS
  end

  def post_install
    system bin/"vscode-lima-install"
  rescue => e
    opoo "Could not auto-install VS Code extension: #{e.message}"
    opoo "Run 'vscode-lima-install' manually to install the extension."
  end

  test do
    assert_path_exists libexec/"lima-manager-0.0.1.vsix"
    assert_path_exists bin/"vscode-lima-install"
    assert_predicate bin/"vscode-lima-install", :executable?
  end
end
