# Template for the Homebrew cask. scripts/render-cask.sh fills in the three at-sign placeholders below.
cask "meter" do
  version "0.1.0"
  sha256 "c259be7b3ae95a018a8aea2865587795fadb076ae8748817d0c168604a1b30e6"

  url "https://github.com/mukulchugh/meter/releases/download/v#{version}/Meter-#{version}.zip"
  name "Meter"
  desc "Menu bar monitor for Anthropic and OpenAI API spend"
  homepage "https://github.com/mukulchugh/meter"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Meter targets macOS 26 (Tahoe). Homebrew's symbol for it is :tahoe.
  depends_on macos: ">= :tahoe"

  app "Meter.app"

  # Meter is signed with a self-signed certificate and is not notarized, so Gatekeeper would show
  # "Meter is damaged and can't be opened" for a quarantined download. Removing the quarantine
  # attribute at install time avoids that. The app is built and signed by its owner and the cask
  # checks the download against the sha256 above before this runs.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Meter.app"]
  end

  # Keychain items (the saved admin keys) are deliberately not removed: a reinstall should keep them.
  zap trash: [
    "~/Library/Application Support/Meter",
    "~/Library/Preferences/dev.meter.app.plist",
  ]
end
