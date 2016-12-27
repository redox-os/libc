#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/redox-os/llvm.git
GIT_BRANCH=redox
DIR=llvm

MAKE_DIR="build"
CONFIGURE="../configure"
CONFIGURE_ARGS="--host=${HOST} --target=${HOST} --enable-static --disable-shared --disable-dlopen --enable-targets=x86_64"
configure_template $*
