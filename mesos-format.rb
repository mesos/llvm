class MesosFormat < Formula
  desc "ClangFormat for Mesos"
  homepage "https://github.com/mesos/clang"

  stable do
    version "2017-11-17"

    url "https://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz"
    sha256 "e35dcbae6084adcf4abb32514127c5eabd7d63b733852ccdb31e06f1373136da"

    resource "clang" do
      url "https://github.com/mesos/clang.git", :branch => "mesos_50"
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

    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
    ]

    mktemp do
      system "cmake", "-G", "Ninja", buildpath, *args
      system "cmake", "--build", ".", "--target", "clang-format"
      system "cmake", "-DCOMPONENT=clang-format", "-P", "cmake_install.cmake"
    end
  end
end
