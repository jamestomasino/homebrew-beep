class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  url "https://github.com/jamestomasino/beep/releases/download/v1.0.0/beep-v1.0.0-linux-x86_64.tar.gz"
  version "1.0.0"
  sha256 "c8f540db7b7a317f8290a4f502e452d80aea2bd9946bf4d1aa0573e6efc0b38d"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "493305be1e060dd4aeb6770248b4fbac661b7febb394df5835e35fdf57452f96"
    end
    on_intel do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "590a3f3f4c4a174f216abeb4474f8be26ccb7aa5b889566f9b4e5622a9e10972"
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
