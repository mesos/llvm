class MesosLlvm < Formula
  desc "Mesos LLVM tools"
  homepage "http://mesos.apache.org"

  stable do
    version "2017-11-11"

    url "https://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz"
    sha256 "e35dcbae6084adcf4abb32514127c5eabd7d63b733852ccdb31e06f1373136da"

    resource "clang" do
      url "https://github.com/mesos/clang.git", :branch => "mesos_50"
    end

    resource "clang-tools-extra" do
      url "https://github.com/mesos/clang-tools-extra.git", :branch => "mesos_50"
    end
  end

  keg_only :provided_by_osx

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

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_BUILD_LLVM_DYLIB=ON"
    ]

    mktemp do
      system "cmake", "-G", "Ninja", buildpath, *(std_cmake_args + args)
      system "cmake", "--build", ".", "--target", "clang-format"
      system "cmake", "-DCOMPONENT=clang-format", "-P", "cmake_install.cmake"
      system "ninja", "tools/clang/tools/extra/clang-apply-replacements/install"
      system "ninja", "tools/clang/tools/extra/clang-tidy/install"
    end
  end
end
