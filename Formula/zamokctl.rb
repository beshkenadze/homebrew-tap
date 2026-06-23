class Zamokctl < Formula
  desc "Drive the Zamok macOS release pipeline from the terminal"
  homepage "https://zamok01.bshk.app"
  url "https://github.com/beshkenadze/homebrew-tap/releases/download/zamokctl-1.2.0/zamokctl-1.2.0-macos-arm64.tar.gz"
  version "1.2.0"
  sha256 "78855769c1e1d96f6833ecc4e394aaf345d1800c6dde21b8fcb277d03ab41280"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "zamokctl"
  end

  test do
    assert_match "zamokctl", shell_output("#{bin}/zamokctl --help")
  end
end
