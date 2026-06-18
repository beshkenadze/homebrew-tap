class Agentvault < Formula
  desc "Agent-agnostic secret broker for AI coding agents (av + avd)"
  homepage "https://github.com/beshkenadze/agentvault"
  url "https://github.com/beshkenadze/agentvault/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c10862607c5d4a2474c2d077bd87696e7d2db7905eb97a615580bd5fc5835cbc"
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
    # Build the two binaries the project ships (mirrors `make build`). av autostarts
    # avd as a sibling on PATH, so both must live in bin. av-enclave-wrap is a niche
    # one-time setup tool for the age-file backend and is intentionally not shipped.
    system "go", "build", *std_go_args(output: bin/"avd"), "./cmd/avd"
    system "go", "build", *std_go_args(output: bin/"av"), "./cmd/av"
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

      Run the broker daemon as a login service (recommended — Touch ID needs the
      GUI session, which this provides):
        brew services start agentvault

      Then, in a project:
        av init --agent claude-code    # generate adapter hook + skill files
        av unlock                      # Touch ID -> opens the session
        av status                      # session state

      (For one-off use `av` also autostarts avd, but the Touch ID prompt is only
      reliable when avd runs as the brew service above.)
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
