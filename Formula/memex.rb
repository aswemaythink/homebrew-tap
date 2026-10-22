class Memex < Formula
  desc "A CLI that indexes a repo's authored intent layer so agents read intent before code."
  homepage "https://aswemaythink.github.io/memex"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.2/agent-memex-aarch64-apple-darwin.tar.xz"
      sha256 "3e7d58e74d9e4ccbc8415c53e623c7e0d1a9c14bb2654bc5406391f0a857fd8d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.2/agent-memex-x86_64-apple-darwin.tar.xz"
      sha256 "5d495898fc8306192ea4cae0791bee73c391ba8dd05c057d072cc7c1053b868c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.2/agent-memex-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b2f07b3d0a283a4b63d75f4fbbcc4f0c01f68285610d75355deb73f18f001a9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.2.2/agent-memex-x86_64-unknown-linux-musl.tar.xz"
      sha256 "fc8bd10682b6cd1456214866cef79e81267aaa03fcfe06edf443831d32a0fe3e"
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
