class Memex < Formula
  desc "A CLI that indexes a repo's authored intent layer so agents read intent before code."
  homepage "https://aswemaythink.github.io/memex"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.1.0/agent-memex-aarch64-apple-darwin.tar.xz"
      sha256 "345dbf360aea86081e00e5b2fe7c88315ebd9976f48c2b2f59c4c4ae4b93de7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.1.0/agent-memex-x86_64-apple-darwin.tar.xz"
      sha256 "77fc235f4212bc1e5d731f926ec99221bcb8762e7e7c8b7559b0d0c88d389e94"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aswemaythink/memex/releases/download/v0.1.0/agent-memex-aarch64-unknown-linux-musl.tar.xz"
      sha256 "251a8c82738e5c2c7372120c3dcbbeded14ddc5db382c0d0d83c0a3d035c9ad5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aswemaythink/memex/releases/download/v0.1.0/agent-memex-x86_64-unknown-linux-musl.tar.xz"
      sha256 "787724d83d37b31efb1b16f0c395fc3ef08857620f9e72cf7e42fed1f532f557"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
