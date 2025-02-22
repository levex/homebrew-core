class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.508",
      revision: "c44008d3d008e20d32967c396809f6b1a85c764f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f221b6bc5abc8686a7bc24be3706818198a8af6b19cade2dd7a0c4ca617f1908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f221b6bc5abc8686a7bc24be3706818198a8af6b19cade2dd7a0c4ca617f1908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f221b6bc5abc8686a7bc24be3706818198a8af6b19cade2dd7a0c4ca617f1908"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d7294a939a1accc7735b6b4c0b58270ae350180c16336dda6c5d46f1ff5eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "b6d7294a939a1accc7735b6b4c0b58270ae350180c16336dda6c5d46f1ff5eb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d7294a939a1accc7735b6b4c0b58270ae350180c16336dda6c5d46f1ff5eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a684ce503dc5e1f8798ebe3529b1e0fc6ac67c19c26f3ec4fabfc7a271d583e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
