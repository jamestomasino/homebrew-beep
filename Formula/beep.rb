class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  version "0.1.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "ab311f22614e7a1f0a4a19e43241833231a9b3d324d21f75b430427ac89f8320"
    else
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "a9a2ade3d1468907111922c76523451c6e70e61e775d84f52ec45d7a07a305ea"
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
