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
  end

  def caveats
    <<~EOS
      AgentVault is macOS-only and gates secrets behind Touch ID.
      `av` autostarts the `avd` daemon on first use — no manual start needed.

      Quick start (in a project):
        av init --agent claude-code    # generate adapter hook + skill files
        av status                      # session state

      Optional: run avd as a resident LaunchAgent.
        https://github.com/beshkenadze/agentvault/blob/main/docs/launchagent.md
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
