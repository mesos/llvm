#!/usr/bin/env bash

VERSION="2017-11-11"

mkdir /tmp/llvm
wget -O - https://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz | tar --strip-components=1 -xJ -C /tmp/llvm
git clone --depth 1 -b mesos_50 https://github.com/mesos/clang.git /tmp/llvm/tools/clang
git clone --depth 1 -b mesos_50 https://github.com/mesos/clang-tools-extra.git /tmp/llvm/tools/clang/tools/extra

source /opt/rh/devtoolset-4/enable
source /opt/rh/python27/enable

cmake -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG \
      -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG \
      -DCMAKE_INSTALL_PREFIX=/mesos-llvm/"${VERSION}" \
      -DCMAKE_FIND_FRAMEWORK=LAST \
      -DLLVM_BUILD_STATIC=ON \
      -DLLVM_OPTIMIZED_TABLEGEN=ON \
      -Wno-dev /tmp/llvm

cmake --build . --target clang-format
cmake -DCOMPONENT=clang-format -P cmake_install.cmake
ninja tools/clang/tools/extra/clang-tidy/install && \
ninja tools/clang/tools/extra/clang-apply-replacements/install && \
tar cf /install/mesos-llvm-"${VERSION}".linux.tar.gz /mesos-llvm
