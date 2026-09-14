class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  url "https://github.com/jamestomasino/beep/releases/download/v1.1.1/beep-v1.1.1-linux-x86_64.tar.gz"
  sha256 "c8f540db7b7a317f8290a4f502e452d80aea2bd9946bf4d1aa0573e6efc0b38d"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "bdb06368c45f7e6350ce662f0a435d12deb93f6c33754ca80c13248b67b91d6b"
    end
    on_intel do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "7dd31db3c306486e742ae2e600136e5bb021f8e7d1c8e9bed90c5cac7c0c3129"
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
