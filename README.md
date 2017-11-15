# LLVM

> Mesos LLVM tools

## Introduction

This repository contains scripts related to building the Mesos LLVM tools.
Specifically, modified versions of `clang-format` and `clang-tidy`
are hosted on [bintray].

## Linux

We build a statically linked binaries on CentOS 6 in a docker container
explicitly in order to link against an "old-enough" `glibc` (2.12).

For a developer tool, this is probably going to be fine for most uses.
The following commands will produce a tarball in your current directory.

```bash
docker build -t mesos-llvm -f mesos-llvm.dockerfile .
docker run --rm -v "$(pwd)":/install:Z mesos-llvm
```

The Linux build is too slow to be hosted on Travis CI, but since running
a docker container is quite accessible, this is currently a manual process.

After producing the tarball with Docker, upload it to [bintray].

## OS X

We leverage [Homebrew Bottles](brew-bottles) to create the binaries on OS X.
In order to simplify the process, we run a job on Travis CI which produces
a `tar.gz` file and uploads the package to [bintray].

[brew-bottles]: https://github.com/Homebrew/brew/blob/master/docs/Bottles.md

## Windows

// TODO

[bintray]: https://bintray.com/apache/mesos/llvm
