class Agentvault < Formula
  desc "Agent-agnostic secret broker for AI coding agents (av + avd)"
  homepage "https://github.com/beshkenadze/agentvault"
  url "https://github.com/beshkenadze/agentvault/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ddfee2703afafc053cc4f37112ebd177480402b81dcae8b05c774495be19aa8e"
  # No SPDX license stanza yet: upstream has not added a LICENSE file. Once it does,
  # set e.g. `license "MIT"` here. `brew install` works without it; `brew audit
  # --strict` will note its absence.
  head "https://github.com/beshkenadze/agentvault.git", branch: "main"

  # macOS-only: the build links Objective-C frameworks via cgo (LocalAuthentication
  # for Touch ID, Security for Keychain, Secure Enclave key wrapping). The non-darwin
  # paths are stubbed to "unsupported", so a Linux build would be non-functional.
  # cgo needs a C/Objective-C compiler; Homebrew already requires the Xcode Command
  # Line Tools, so clang is guaranteed — no separate xcode dependency needed.
  depends_on "go" => :build
  depends_on :macos

  def install
    ENV["CGO_ENABLED"] = "1"
    # Stamp the release version into both binaries so `av version` reports it (and can
    # flag an av/avd mismatch after an upgrade). av autostarts avd as a sibling on PATH,
    # so both must live in bin. av-enclave-wrap is a niche one-time setup tool for the
    # age-file backend and is intentionally not shipped.
    ldflags = "-X main.version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"avd", ldflags: ldflags), "./cmd/avd"
    system "go", "build", *std_go_args(output: bin/"av", ldflags: ldflags), "./cmd/av"
    (var/"log/agentvault").mkpath
  end

  # `brew services start agentvault` runs avd as a per-user LaunchAgent in the GUI
  # (Aqua) session — the ONLY context where the Touch ID prompt can appear (a root
  # LaunchDaemon cannot). It auto-starts at login and is kept alive. Backends that
  # need configuration (the age-file backend's AV_AGE_VAULT / AV_AGE_IDENTITY) can be
  # added here via `environment_variables`; Keychain and 1Password need none.
  service do
    run [opt_bin/"avd"]
    keep_alive true
    log_path var/"log/agentvault/avd.log"
    error_log_path var/"log/agentvault/avd.err.log"
  end

  def caveats
    <<~EOS
      AgentVault is macOS-only and gates secrets behind Touch ID.

      Set up the broker (one time — Touch ID needs the GUI session the service runs in):
        brew services start agentvault   # avd as a login LaunchAgent
        av setup                         # provision the local vault (auto-picks the tier)
        av add GITHUB_TOKEN              # first op auto-prompts Touch ID; value via hidden prompt

      Then, in a project with an agentvault.yaml:
        av run --profile smoke -- your-cmd   # secret injected; output masked to {{AV:NAME}}

      Key protection: this build-from-source install stores the age key in your login
      Keychain (OS-encrypted). The Secure Enclave tier needs a signed build (planned
      Cask). `av unlock` is optional — operations unlock on demand.

      After `brew upgrade` no manual restart is needed — `av` self-heals a stale daemon
      (av version shows av/avd + active tier).
      Keychain/1Password are read-only here (populate with `security` / `op`).
      Agent adapter files: av init --agent claude-code
    EOS
  end

  test do
    # `av` with no args prints usage to stderr and exits 2 — no daemon required.
    assert_match "av run", shell_output("#{bin}/av 2>&1", 2)

    # `av init` is a pure generator (no daemon/backend): exercise the real code path.
    system bin/"av", "init", "--agent", "generic", "--dir", testpath
    refute_empty Dir.children(testpath), "av init wrote no files"
  end
end
