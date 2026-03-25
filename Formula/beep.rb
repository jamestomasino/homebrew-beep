class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  version "0.1.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "90ed01f51294ea990adcdad947abca7ef4e1da8c1958d1e714dd2c1d1dddf9f6"
    else
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "b97910d16b68c88d6bc5fc2c14ad06df2d3af146f67cd7e70785ea808ff76d4d"
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
