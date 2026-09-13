class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  url "https://github.com/jamestomasino/beep/releases/download/v0.1.8/beep-v0.1.8-linux-x86_64.tar.gz"
  version "0.1.8"
  sha256 "b9845bc5816b199892e453c53b26bd00cc0561830458c56b63d52134f4e00adc"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "90bf070bfe80b3b79d9ec19c824a21b3560bd0cd2a311ee2bd8e3fad160c3e0e"
    end
    on_intel do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "1f2f74dc340616837687b7d675a5f27513a0953d425f655c78f5a1ba330e4450"
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
