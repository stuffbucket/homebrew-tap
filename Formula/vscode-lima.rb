class VscodeLima < Formula
  desc "VS Code extension installer for managing Lima virtual machines"
  homepage "https://github.com/stuffbucket/vscode-lima"
  url "https://github.com/stuffbucket/vscode-lima/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "3323885942b0d3d584690a3059e5ee2cd133b4ae8195ddbd8fc09948c5ac5036"
  license "MIT"

  depends_on "lima"

  def install
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

      echo "Installing Lima Manager extension from VS Code Marketplace..."
      "$VSCODE_BIN" --install-extension stuffbucket-co.lima-manager
      echo "✅ Lima Manager extension installed successfully!"
      echo ""
      echo "The extension will auto-update through VS Code."
    EOS

    chmod 0755, bin/"vscode-lima-install"
  end

  def caveats
    <<~EOS
      To install the Lima Manager extension, run:
        vscode-lima-install

      Or install directly in VS Code:
        1. Press Cmd+Shift+X (Extensions view)
        2. Search for "Lima Manager"
        3. Click Install

      The extension will auto-update through VS Code.
    EOS
  end

  test do
    assert_path_exists bin/"vscode-lima-install"
    assert_predicate bin/"vscode-lima-install", :executable?
  end
end
