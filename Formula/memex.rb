class Memex < Formula
  desc "A CLI that indexes a repo's authored intent layer so agents read intent before code."
  homepage "https://aswemaythink.github.io/memex"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.0/agent-memex-aarch64-apple-darwin.tar.xz"
      sha256 "1d712b8c116b443eed9f491eb0387c31c0025037624f1c8a1552b9ead4b7a235"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.0/agent-memex-x86_64-apple-darwin.tar.xz"
      sha256 "16e35a4e812e1582c4bd2c8c10218bc9f965af4e61a8093e09f03b3e8583f729"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.0/agent-memex-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e5cdb0722949ebb392f68cb7e6767ae627b321d444229a0e99b6cf43750ab80b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.0/agent-memex-x86_64-unknown-linux-musl.tar.xz"
      sha256 "98789a1e848e5d9397aaa3d1adfcf6e77eab0fd0927e310f36bce6850268eb9b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

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
      bin.install "memex"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "memex"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "memex"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "memex"
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
