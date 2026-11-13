class Setu < Formula
  desc "Runs every worktree's app and workers side by side, each at its own local URL"
  homepage "https://github.com/mukulchugh/setu"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mukulchugh/setu/releases/download/v0.1.4/setu-aarch64-apple-darwin.tar.xz"
      sha256 "9825e84af8c3a9e93b3b6df194517783775be264e7f9bd0e7c24024c32861d26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mukulchugh/setu/releases/download/v0.1.4/setu-x86_64-apple-darwin.tar.xz"
      sha256 "cd552399042526d0902195b2efa6d31b50b374f1023dc9043641d2663c150378"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "setu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "setu"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
