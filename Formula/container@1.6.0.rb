class ContainerAT160 < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://github.com/beshkenadze/container"
  url "https://github.com/beshkenadze/container/releases/download/1.6.0-bshk.2/container-1.6.0-bshk.2-installer-signed.pkg"
  version "1.6.0-bshk.2"
  sha256 "048cbe2bd5bf1c4c011d5edfae43f2dca2a38e7269d9016bfbbb68017ed48b4f"
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
