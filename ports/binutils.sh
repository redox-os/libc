#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/binutils-gdb.git
DIR=binutils-gdb

CONFIGURE_ARGS="--host=${HOST} --target=${HOST} --prefix=${PREFIX} --with-sysroot=${SYSROOT} --disable-gdb --disable-nls --disable-werror"
configure_template $*
