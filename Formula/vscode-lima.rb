class VscodeLima < Formula
  desc "VS Code extension for managing Lima virtual machines"
  homepage "https://github.com/stuffbucket/vscode-lima"
  url "https://github.com/stuffbucket/vscode-lima/releases/download/v0.0.1/lima-manager-0.0.1.vsix"
  sha256 "6d1d9a4a66cd30b86814c0c7299e043be6668f0456690513f4b1c03653be7a99"
  version "0.0.1"
  license "MIT"

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

  test do
    assert_predicate libexec/"lima-manager-#{version}.vsix", :exist?
    assert_predicate bin/"vscode-lima-install", :exist?
    assert_predicate bin/"vscode-lima-install", :executable?
  end
end
