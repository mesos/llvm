$TOOL = "mesos-format"
$VERSION = "2018-03-08"
$PREFIX = "${TOOL}/${VERSION}"

wget https://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz -OutFile llvm-6.0.0.src.tar.xz
7z e llvm-6.0.0.src.tar.xz
7z x llvm-6.0.0.src.tar
mv llvm-6.0.0.src llvm

git clone -q --depth 1 -b mesos_60 https://github.com/mesos/clang.git llvm/tools/clang

cmake -G "Visual Studio 15 2017 Win64" -Thost=x64 -DCMAKE_INSTALL_PREFIX="${PREFIX}" llvm

cmake --build . --target clang-format --config Release -- /m:2
cmake -DCOMPONENT=clang-format -P cmake_install.cmake

Compress-Archive -DestinationPath "${TOOL}-${VERSION}.windows.zip" -Path "${TOOL}"
