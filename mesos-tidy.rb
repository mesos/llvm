class MesosTidy < Formula
  desc "ClangTidy for Mesos"
  homepage "https://github.com/mesos/clang-tools-extra"

  stable do
    version "2018-03-08"

    url "https://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz"
    sha256 "1ff53c915b4e761ef400b803f07261ade637b0c269d99569f18040f3dcee4408"

    resource "clang" do
      url "https://github.com/mesos/clang.git", :branch => "mesos_60"
    end

    resource "clang-tools-extra" do
      url "https://github.com/mesos/clang-tools-extra.git", :branch => "mesos_60"
    end
  end

  keg_only :provided_by_macos

  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-tools-extra")

    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
    ]

    mktemp do
      system "cmake", "-G", "Ninja", buildpath, *args
      system "cmake", "--build", ".", "--target", "tools/clang/tools/extra/clang-tidy/install"
      system "cmake", "--build", ".", "--target", "tools/clang/tools/extra/clang-apply-replacements/install"
      system "rm", "-r", prefix/"lib"
      system "cmake", "--build", ".", "--target", "tools/clang/lib/Headers/install"
    end
  end
end
