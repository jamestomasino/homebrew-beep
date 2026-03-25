class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  version "0.1.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "f29db6536f1ee6fb6bdfe84a419ea172fa36edb40bee7716a276c1618b594d81"
    else
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "0b568d356d58a550c00dcaf3b638c3d9abc09c0aa5641e38c2c7e9c938758201"
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
