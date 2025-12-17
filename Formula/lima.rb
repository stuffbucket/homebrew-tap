class Lima < Formula
  desc "Linux virtual machines with GUI desktop support via VZ"
  homepage "https://lima-vm.io/"
  url "https://github.com/stuffbucket/lima/archive/refs/tags/v2.0.0-beta-0.4-fork.tar.gz"
  version "2.0.0-beta.0.4"
  sha256 "8eae374a6b529623d254a12c0d193137b8572dc068a432108023300b30347a42"
  license "Apache-2.0"
  head "https://github.com/stuffbucket/lima.git", branch: "master"

  depends_on "go" => :build

  on_linux do
    depends_on "qemu"
  end

  def install
    system "make", "native", "VERSION=#{version}"
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
