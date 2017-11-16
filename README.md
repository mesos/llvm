# LLVM

> Mesos LLVM tools

## Introduction

This repository contains scripts related to building the Mesos LLVM tools.
Specifically, modified versions of `clang-format` and `clang-tidy`.

Building / uploading of `mesos-format` is automated by Travis CI and
AppVeyor jobs, while `mesos-tidy` needs to be built / uploaded manually
due to the build timeout limits (1 hour) on those services.

## Linux

We build statically linked binaries on CentOS 6 in a docker container
specifically to link against an "old-enough" `glibc` (2.12).

For a developer tool, this is probably going to be fine for most uses.

The following commands will produce a `tar.gz` file with the naming scheme
`<tool>-<version>.linux.tar.gz` (e.g, `mesos-tidy-2017-11-17.linux.tar.gz`)
in your current directory.

```bash
docker build -t mesos-tidy -f mesos-tidy.dockerfile .
docker run --rm -v "$(pwd)":/INSTALL:Z mesos-tidy
```

## OS X

We leverage [Homebrew Bottles](brew-bottles) to create the packages on OS X.

The following commands will produce a `tar.gz` file with the naming scheme
`<tool>-<version>.<osx>.tar.gz` (e.g., `mesos-tidy-2017-11-17.sierra.tar.gz`)
in your current directory.

```bash
brew tap mesos/llvm https://github.com/mesos/llvm
brew install --build-bottle mesos-tidy
brew bottle mesos-tidy
brew uninstall mesos-tidy
brew untap mesos/llvm
```

[brew-bottles]: https://github.com/Homebrew/brew/blob/master/docs/Bottles.md

## Windows

// TODO

[bintray]: https://bintray.com/apache/mesos/llvm
