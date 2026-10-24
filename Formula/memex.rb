class Memex < Formula
  desc "A CLI that indexes a repo's authored intent layer so agents read intent before code."
  homepage "https://aswemaythink.github.io/memex"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.1/agent-memex-aarch64-apple-darwin.tar.xz"
      sha256 "6070ccc8b529144f04b0836c5c73842512103fc6fc1addef91dc9685ee348a82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.1/agent-memex-x86_64-apple-darwin.tar.xz"
      sha256 "f2b86ece1a51214d6b65072567874fd4a5b639a4b11a8ec93bf506f21c88d467"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.1/agent-memex-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fcdaebda88b8fddf9ab3112d70cd34efcd1d2c6ef95e133153d8a0fb9c246919"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.1/agent-memex-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4922ba6e9f18db915fd6aefbe30b99dbb0063be43e3badf74e4be279ce2a29dc"
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
