class Lima < Formula
  desc "Linux virtual machines with GUI desktop support via VZ"
  homepage "https://lima-vm.io/"
  url "https://github.com/stuffbucket/lima/archive/refs/tags/v2.0.0-beta.0-fork.tar.gz"
  sha256 "b763786b941b220847f1c82f36dfbf40a846401e9dd43488885b4a2e56859894"
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
