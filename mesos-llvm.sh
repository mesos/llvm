#!/usr/bin/env bash

VERSION="2017-11-15"
PREFIX="/mesos-llvm/${VERSION}"

mkdir /tmp/llvm
wget -O - https://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz | tar --strip-components=1 -xJ -C /tmp/llvm
git clone --depth 1 -b mesos_50 https://github.com/mesos/clang.git /tmp/llvm/tools/clang
git clone --depth 1 -b mesos_50 https://github.com/mesos/clang-tools-extra.git /tmp/llvm/tools/clang/tools/extra

source /opt/rh/devtoolset-4/enable
source /opt/rh/python27/enable

cmake -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DLLVM_BUILD_STATIC=ON \
      -DLLVM_OPTIMIZED_TABLEGEN=ON /tmp/llvm

cmake --build . --target clang-format
cmake -DCOMPONENT=clang-format -P cmake_install.cmake
cmake --build . --target tools/clang/tools/extra/clang-tidy/install
cmake --build . --target tools/clang/tools/extra/clang-apply-replacements/install
rm -r "${PREFIX}/lib"
cmake --build . --target tools/clang/lib/Headers/install
tar cf /install/mesos-llvm-"${VERSION}".linux.tar.gz /mesos-llvm
