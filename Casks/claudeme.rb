cask "claudeme" do
  version "0.1.0"
  sha256 "a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2"

  url "https://github.com/stuffbucket/claudeme/releases/download/v#{version}/Claudeme-#{version}.zip"
  name "Claudeme"
  name "Open in Claude Code"
  desc "Finder toolbar app to launch Claude Code in the current directory"
  homepage "https://github.com/stuffbucket/claudeme"

  app "Open in Claude Code.app"

  caveats <<~EOS
    To use Claudeme:
    1. Hold ⌘ and drag the app from /Applications to Finder's toolbar
    2. Navigate to any project folder
    3. Click the toolbar icon to open Claude Code there

    Double-click the app to access Settings.
  EOS
end
