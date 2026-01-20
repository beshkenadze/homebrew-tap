class Kaban < Formula
  desc "Terminal Kanban for AI Code Agents"
  homepage "https://beshkenadze.github.io/kaban"
  url "https://registry.npmjs.org/@kaban-board/cli/-/cli-0.2.6.tgz"
  sha256 "91f6eb51be725f6c04981f46ef9a0e8daf85ac6219498db9695eba3b4f91b631"
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
