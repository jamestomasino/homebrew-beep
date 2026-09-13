class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  url "https://github.com/jamestomasino/beep/releases/download/v0.1.7/beep-v0.1.7-linux-x86_64.tar.gz"
  version "0.1.7"
  sha256 "3933ccbe02cdd164d9c040621fffa7c8b862180d58c0748e46256c86745a1b1f"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "abd272bb2898d9f3bd87cef6fd605d70d7bad00eabdeacd793cb1136f4ee8b74"
    end
    on_intel do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "3c8752803e9313f136dbf2a4df8d969779b2af4596ca594282e308f4eb1f8283"
    end
  end

  on_linux do
    on_arm do
      disable! date: "2026-03-25", because: :unsupported
    end
  end

  def install
    bin.install "bin/beep"
    doc.install "README.md"
  end

  test do
    assert_match "beep", shell_output("#{bin}/beep --version")
  end
end
