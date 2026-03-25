class Beep < Formula
  desc "Activity sonifier CLI"
  homepage "https://github.com/jamestomasino/beep"
  version "0.1.6"

  on_macos do
    on_arm do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-arm64.tar.gz"
      sha256 "cb58c43bd8910613cab946758ae3e24a2472a3f833711828fb9c26d4d89b3d48"
    end
    on_intel do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-darwin-x86_64.tar.gz"
      sha256 "c48c1c199ee805f8008c39c2054d5178de8d958b6bf24e2735d93697d877fcdc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jamestomasino/beep/releases/download/v#{version}/beep-v#{version}-linux-x86_64.tar.gz"
      sha256 "0f54336068a49e8e1cc6d223914c8d72f4408ac2100a8a4022a2547d156bc68f"
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
