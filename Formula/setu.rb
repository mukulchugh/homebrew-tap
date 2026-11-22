class Setu < Formula
  desc "Runs every worktree's app and workers side by side, each at its own local URL"
  homepage "https://github.com/mukulchugh/setu"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mukulchugh/setu/releases/download/v0.1.11/setu-aarch64-apple-darwin.tar.xz"
      sha256 "91b68225ced18525fa369da2a49af692e2a933eff5aa7e116e1c8bd1dde68002"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mukulchugh/setu/releases/download/v0.1.11/setu-x86_64-apple-darwin.tar.xz"
      sha256 "2f2f318444fe9f95fccc81bd3630cda9517e5cce0fcd3b5a69ab8633b41cc58c"
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
