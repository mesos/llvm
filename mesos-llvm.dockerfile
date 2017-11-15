FROM centos:6
MAINTAINER The Apache Mesos Developers <dev@mesos.apache.org>

WORKDIR /tmp/build

RUN yum install -y centos-release-scl && \
    yum install -y devtoolset-4-binutils devtoolset-4-gcc-c++ git glibc-static python27 unzip wget xz && \
    alternatives --install /opt/rh/devtoolset-4/root/usr/bin/ld ld /opt/rh/devtoolset-4/root/usr/bin/ld.gold 50

RUN wget https://cmake.org/files/v3.8/cmake-3.8.2-Linux-x86_64.sh && \
    bash cmake-3.8.2-Linux-x86_64.sh --skip-license --prefix=/usr/local

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && \
    unzip ninja-linux.zip -d /usr/local/bin

ENV TOOL="mesos-tidy"
ENV VERSION="2017-11-11"

ENTRYPOINT \
    mkdir /tmp/llvm && \
    wget -O - https://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz | tar --strip-components=1 -xJ -C /tmp/llvm && \
    git clone --depth 1 -b mesos_50 https://github.com/mesos/clang.git /tmp/llvm/tools/clang && \
    git clone --depth 1 -b mesos_50 https://github.com/mesos/clang-tools-extra.git /tmp/llvm/tools/clang/tools/extra && \
    scl enable devtoolset-4 python27 -- \
    cmake -GNinja \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/"${TOOL}/${VERSION}" \
          -DLLVM_BUILD_STATIC=ON /tmp/llvm && \
    ninja tools/clang/tools/extra/clang-tidy/install && \
    ninja tools/clang/tools/extra/clang-apply-replacements/install && \
    tar cf /install/"${TOOL}-${VERSION}".linux.tar.gz /"${TOOL}"
