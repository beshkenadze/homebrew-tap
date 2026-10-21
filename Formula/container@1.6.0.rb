class ContainerAT160 < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://github.com/beshkenadze/container"
  url "https://github.com/beshkenadze/container/releases/download/1.6.0-bshk.1/container-1.6.0-bshk.1-installer-signed.pkg"
  version "1.6.0-bshk.1"
  sha256 "9017fb32c6417b514ae35fa863418b5a40f321b0efe8a4b74b0dcf83e89776fd"
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    system "pkgutil", "--expand-full", cached_download, "expanded"
    prefix.install Dir[buildpath/"expanded/Payload/*"]
  end

  test do
    assert_match "1.6.0", shell_output("#{bin}/container --version")
  end
end
