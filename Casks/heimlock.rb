cask "heimlock" do
  version "0.8.0"
  sha256 "97ca397b408ae05aed12072450e0dbfbbbff4c6a3b299820ea605d064b18cf9c"

  url "https://github.com/ar-lenz/heimlock/releases/download/heimlock-v#{version}/Heimlock-macos-arm64.dmg"
  name "Heimlock"
  desc "Agentic IDE with a built-in slop-killing code-review gate"
  homepage "https://github.com/ar-lenz/heimlock"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"
  depends_on formula: "semgrep"

  app "Heimlock.app"
  binary "#{appdir}/Heimlock.app/Contents/Resources/heimlock/heimlock"
  binary "#{appdir}/Heimlock.app/Contents/Resources/heimlock/heimlockd"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Heimlock.app"]

    internal_bin = File.expand_path("~/.heimlock/internal/bin")
    FileUtils.mkdir_p(internal_bin)

    bundled_gitleaks = "#{appdir}/Heimlock.app/Contents/Resources/heimlock/internal/bin/gitleaks"
    if File.exist?(bundled_gitleaks)
      FileUtils.cp(bundled_gitleaks, File.join(internal_bin, "gitleaks"))
      FileUtils.chmod(0755, File.join(internal_bin, "gitleaks"))
    end

    brew_semgrep = "#{HOMEBREW_PREFIX}/bin/semgrep"
    FileUtils.ln_sf(brew_semgrep, File.join(internal_bin, "semgrep")) if File.exist?(brew_semgrep)

    system_command "#{appdir}/Heimlock.app/Contents/Resources/heimlock/heimlock",
                   args:         ["daemon", "install"],
                   must_succeed: false
  end

  uninstall_preflight do
    system_command "#{appdir}/Heimlock.app/Contents/Resources/heimlock/heimlock",
                   args:         ["daemon", "stop"],
                   must_succeed: false
    system_command "/bin/rm",
                   args:         ["-f", File.expand_path("~/Library/LaunchAgents/dev.heimlock.daemon.plist")],
                   must_succeed: false
  end

  zap trash: "~/.heimlock"

  caveats <<~EOS
    Heimlock is Apple Silicon only for now and ad-hoc signed (not
    Apple-notarised). The postflight clears the quarantine attribute
    automatically. If you still see a Gatekeeper warning on first launch:

        sudo xattr -cr /Applications/Heimlock.app
  EOS
end
