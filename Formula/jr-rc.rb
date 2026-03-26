class JrRc < Formula
  desc "Fast, keyboard-driven Jira CLI with offline support and fuzzy search (release candidate channel)"
  homepage "https://github.com/arcavenae/jira-cli"
  version "VERSION_PLACEHOLDER"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/arcavenae/jira-cli/releases/download/TAG_PLACEHOLDER/jr-darwin-arm64"
    sha256 "SHA256_ARM64_PLACEHOLDER"
  else
    url "https://github.com/arcavenae/jira-cli/releases/download/TAG_PLACEHOLDER/jr-darwin-amd64"
    sha256 "SHA256_AMD64_PLACEHOLDER"
  end

  def install
    binary_name = Hardware::CPU.arm? ? "jr-darwin-arm64" : "jr-darwin-amd64"
    bin.install binary_name => "jr-rc"
  end

  def caveats
    <<~EOS
      jr-rc is the release candidate channel. Updates on every v*-rc.* tag.
      For stable: brew install arcavenae/tap/jr
    EOS
  end

  test do
    assert_match "jr", shell_output("#{bin}/jr-rc --version 2>&1")
  end
end
