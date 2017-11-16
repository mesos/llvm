$VERSION="2017-11-15"
$PREFIX="mesos-llvm/${VERSION}"

mkdir llvm
wget -O - https://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz | tar --strip-components=1 -xJ -C llvm
git clone --depth 1 -b mesos_50 https://github.com/mesos/clang.git llvm/tools/clang
git clone --depth 1 -b mesos_50 https://github.com/mesos/clang-tools-extra.git llvm/tools/clang/tools/extra

cmake -Thost=x64 -DCMAKE_INSTALL_PREFIX="${PREFIX}" llvm

cmake --build . --target clang-format --config Release
cmake -DCOMPONENT=clang-format -P cmake_install.cmake

cmake --build . --target tools/clang/tools/extra/clang-tidy/install --config Release
cmake --build . --target tools/clang/tools/extra/clang-apply-replacements/install --config Release
rm -r "${PREFIX}/lib"
cmake --build . --target tools/clang/lib/Headers/install

Compress-Archive -DestinationPath "mesos-llvm-${VERSION}.windows.zip" -Path mesos-llvm
