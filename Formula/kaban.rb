class Kaban < Formula
  desc "Terminal Kanban for AI Code Agents"
  homepage "https://beshkenadze.github.io/kaban"
  url "https://registry.npmjs.org/@kaban-board/cli/-/cli-0.2.8.tgz"
  sha256 "1fc09cc997bfed399250a1854061afa13e5149e35902eab268331123bd701667"
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
