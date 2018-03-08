FROM centos:6
MAINTAINER The Apache Mesos Developers <dev@mesos.apache.org>

WORKDIR /tmp/build

RUN yum install -y centos-release-scl && \
    yum install -y devtoolset-4-binutils devtoolset-4-gcc-c++ git glibc-static python27 unzip wget xz && \
    alternatives --install /opt/rh/devtoolset-4/root/usr/bin/ld ld /opt/rh/devtoolset-4/root/usr/bin/ld.gold 50

RUN wget https://cmake.org/files/v3.8/cmake-3.8.2-Linux-x86_64.sh && \
    bash cmake-3.8.2-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.8.2-Linux-x86_64.sh

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && \
    unzip ninja-linux.zip -d /usr/local/bin && \
    rm ninja-linux.zip

ENTRYPOINT \
  TOOL="mesos-format" && \
  VERSION="2018-03-08" && \
  PREFIX="/${TOOL}/${VERSION}" && \
  \
  mkdir /tmp/llvm && \
  wget -O - https://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz | tar --strip-components=1 -xJ -C /tmp/llvm && \
  git clone --depth 1 -b mesos_60 https://github.com/mesos/clang.git /tmp/llvm/tools/clang && \
  \
  source /opt/rh/devtoolset-4/enable && \
  source /opt/rh/python27/enable && \
  \
  cmake -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DLLVM_BUILD_STATIC=ON \
        -DLLVM_OPTIMIZED_TABLEGEN=ON /tmp/llvm && \
  \
  cmake --build . --target clang-format && \
  cmake -DCOMPONENT=clang-format -P cmake_install.cmake && \
  \
  tar -czvf /INSTALL/"${TOOL}"-"${VERSION}".linux.tar.gz /"${TOOL}"
