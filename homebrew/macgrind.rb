class Macgrind < Formula
  desc "Valgrind for macOS — runs Valgrind in a local Docker container"
  homepage "https://github.com/shaansriram8/macgrind"
  license "MIT"
  version "0.1.0"

  url "https://github.com/shaansriram8/macgrind/releases/download/v0.1.0/macgrind-0.1.0-arm64-apple-darwin.tar.gz"
  sha256 "f9cd4cd26c0d49e28d089e54de39af8e18aac55a9107aa9e791e2508cb769976"

  # 'docker' installs the Docker CLI.  Docker Desktop (a cask) provides the
  # container runtime — see the caveats block below.
  depends_on "docker"

  def install
    bin.install "macgrind"
  end

  def caveats
    <<~EOS
      macgrind launches containers using the local Docker daemon.
      Make sure Docker Desktop is installed and running before use:

        https://www.docker.com/products/docker-desktop/

      The `docker` formula installed by Homebrew provides only the CLI client.
      Docker Desktop provides the daemon that actually runs containers.

      On the first invocation, macgrind will build a small Ubuntu image
      (~200 MB download).  Subsequent runs reuse the cached image and start
      in seconds.
    EOS
  end

  test do
    output = shell_output("#{bin}/macgrind --version")
    assert_match "macgrind", output
  end
end
