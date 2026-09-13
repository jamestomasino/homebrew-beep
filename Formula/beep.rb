class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  url "https://github.com/jamestomasino/beep/releases/download/v1.1.0/beep-v1.1.0-linux-x86_64.tar.gz"
  version "1.1.0"
  sha256 "c8f540db7b7a317f8290a4f502e452d80aea2bd9946bf4d1aa0573e6efc0b38d"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "987088e6cea81654af7b98fe3fffdd495d98c14656f3270e730dd5a7d49003b0"
    end
    on_intel do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "5429e48627ca04d9fc221be7a20fbda89d94932f2599e41545cb1ef42216fd4a"
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
