class Lima < Formula
  desc "Linux virtual machines with GUI desktop support via VZ"
  homepage "https://lima-vm.io/"
  url "https://github.com/stuffbucket/lima/archive/refs/tags/v1.0.0.tar.gz"
  version "1.0.0-fork"
  sha256 "f0692f34524542fc882a7d81dabe420a72c344d94091a05a15aa3d64acddf588"
  license "Apache-2.0"
  head "https://github.com/stuffbucket/lima.git", branch: "master"

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

  def install
    system "make", "native", "VERSION=1.0.0-fork"
    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]
    generate_completions_from_executable(bin/"limactl", "completion")
  end

  def caveats
    <<~EOS
      The guest agents for non-native architectures are now provided in a separate formula:
        brew install lima-additional-guestagents
    EOS
  end

  test do
    info = JSON.parse shell_output("#{bin}/limactl info")
    assert_includes info["vmTypes"], "qemu"
    assert_includes info["vmTypes"], "vz" if OS.mac?
    template_names = info["templates"].map { |x| x["name"] }
    assert_includes template_names, "default"
  end
end
