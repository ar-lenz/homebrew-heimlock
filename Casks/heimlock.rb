cask "heimlock" do
  version "0.10.3"
  sha256 "48f6a12032fcccec47b3bc04317bbb2248fd78c925f67042127c744a813f11ee"

  url "https://github.com/ar-lenz/homebrew-heimlock/releases/download/v#{version}/Heimlock-macos-arm64.dmg"
  name "Heimlock"
  desc "Agentic IDE with a built-in slop-killing code-review gate"
  homepage "https://github.com/ar-lenz/heimlock"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura
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

    heimlock_bin = "#{appdir}/Heimlock.app/Contents/Resources/heimlock/heimlock"
    if File.exist?(heimlock_bin)
      system_command heimlock_bin,
                     args:         ["daemon", "install"],
                     must_succeed: false
    end
  end

  uninstall_preflight do
    heimlock_bin = "#{appdir}/Heimlock.app/Contents/Resources/heimlock/heimlock"
    if File.exist?(heimlock_bin)
      system_command heimlock_bin,
                     args:         ["daemon", "stop"],
                     must_succeed: false
    end
    system_command "/bin/rm",
                   args:         ["-f", File.expand_path("~/Library/LaunchAgents/dev.heimlock.daemon.plist")],
                   must_succeed: false
  end

  zap trash: [
    "~/.heimlock",
    "~/Library/Application Support/heimlock-engine",
  ]
end
