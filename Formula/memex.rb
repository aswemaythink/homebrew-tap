class Memex < Formula
  desc "A CLI that indexes a repo's authored intent layer so agents read intent before code."
  homepage "https://aswemaythink.github.io/memex"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.0/agent-memex-aarch64-apple-darwin.tar.xz"
      sha256 "750eb3e5bac77e69b69faa4fc061fedd94be9c74aa1345120f2c0666bf07ed6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.0/agent-memex-x86_64-apple-darwin.tar.xz"
      sha256 "a429a0187e289e62da9b2c090febdaef9014e9c679739783833b9ddd7aeda86f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.0/agent-memex-aarch64-unknown-linux-musl.tar.xz"
      sha256 "04e3b534237a9b9495f11323dfcf1a402fc0548df8465d597b5288c29f1f8bd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.3.0/agent-memex-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7af7a45137c07dab8ae5e1388064b2578bd7a6faa4555cd51bdc27e92ee63210"
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
