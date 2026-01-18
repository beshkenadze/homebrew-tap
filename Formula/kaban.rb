class Kaban < Formula
  desc "Terminal Kanban for AI Code Agents"
  homepage "https://beshkenadze.github.io/kaban"
  url "https://registry.npmjs.org/@kaban-board/cli/-/cli-0.1.3.tgz"
  sha256 "172de13cebec4686a9fcdf16603895e2a064000ce89c201f2f02d505848c5b27"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Terminal Kanban", shell_output("#{bin}/kaban --help")
  end
end
