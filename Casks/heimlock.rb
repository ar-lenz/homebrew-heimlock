cask "heimlock" do
  version "0.5.11"
  sha256 "383266754b4ea228f8aa59dbcf54eee8d362eaaba006e8affb5d5369ccb21d9c"

  url "https://github.com/ar-lenz/homebrew-heimlock/raw/main/files/Heimlock-0.5.11-universal.dmg"
  name "Heimlock"
  desc "Local-first gate that turns every git push into a slop-free PR"
  homepage "https://github.com/ar-lenz/heimlock"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"
  depends_on formula: "semgrep"

  app "Heimlock.app"
  binary "#{appdir}/Heimlock.app/Contents/MacOS/heimlock"
  binary "#{appdir}/Heimlock.app/Contents/MacOS/heimlockd"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Heimlock.app"]

    internal_bin = File.expand_path("~/.heimlock/internal/bin")
    FileUtils.mkdir_p(internal_bin)

    bundled_gitleaks = "#{appdir}/Heimlock.app/Contents/Resources/internal/bin/gitleaks"
    if File.exist?(bundled_gitleaks)
      FileUtils.cp(bundled_gitleaks, File.join(internal_bin, "gitleaks"))
      FileUtils.chmod(0755, File.join(internal_bin, "gitleaks"))
    end

    brew_semgrep = "#{HOMEBREW_PREFIX}/bin/semgrep"
    FileUtils.ln_sf(brew_semgrep, File.join(internal_bin, "semgrep")) if File.exist?(brew_semgrep)

    system_command "#{appdir}/Heimlock.app/Contents/MacOS/heimlock",
                   args:         ["daemon", "install"],
                   must_succeed: false
  end

  uninstall_preflight do
    system_command "#{appdir}/Heimlock.app/Contents/MacOS/heimlock",
                   args:         ["daemon", "stop"],
                   must_succeed: false
    system_command "/bin/rm",
                   args:         ["-f", File.expand_path("~/Library/LaunchAgents/dev.heimlock.daemon.plist")],
                   must_succeed: false
  end

  zap trash: "~/.heimlock"

  caveats <<~EOS
    Heimlock is ad-hoc signed (not Apple-notarised). The postflight
    clears the quarantine attribute automatically. If you still see
    a Gatekeeper warning on first launch, run:

        sudo xattr -cr /Applications/Heimlock.app
  EOS
end
