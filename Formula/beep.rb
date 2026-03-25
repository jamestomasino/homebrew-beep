class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  version "0.1.5"
  depends_on :macos

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "9d7158bdbaf1b2079c9a7ae26f3f771706b006ba275c714df12cb546d165fd42"
    else
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "9b5d535aa2d2ec35384858898ac683e039bb78e089fdadb2a9b29bf5b0c110af"
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
