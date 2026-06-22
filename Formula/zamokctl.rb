class Zamokctl < Formula
  desc "CLI to drive the Zamok macOS release pipeline (codesign, notarize, staple, package, upload, publish)"
  homepage "https://zamok01.bshk.app"
  version "1.1.0"
  url "https://github.com/beshkenadze/homebrew-tap/releases/download/zamokctl-1.1.0/zamokctl-1.1.0-macos-arm64.tar.gz"
  sha256 "69b02407b633f175ff80c25b10f454a9ee44bafb472e49aa34ad79b203f0bbf2"
  license :cannot_represent

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "zamokctl"
  end

  test do
    assert_match "zamokctl", shell_output("#{bin}/zamokctl --help")
  end
end
