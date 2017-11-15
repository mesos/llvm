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

COPY ./mesos-llvm.sh /
ENTRYPOINT [ "/mesos-llvm.sh" ]
