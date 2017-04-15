#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/binutils-gdb.git
DIR=binutils-gdb

CONFIGURE_ARGS="--host=${HOST} --target=${HOST} --prefix=${PREFIX} --with-sysroot=${SYSROOT} --disable-gdb --disable-nls --disable-werror"

case $1 in
    add)
        fetch_template add
        mkdir -p "${BUILD}/${DIR}/${MAKE_DIR}"
        pushd "${BUILD}/${DIR}/${MAKE_DIR}"
            autoconf2.64 $AUTOCONF_ARGS
        popd
        configure_template configure
        make_template build
        make_template install
        ;;
    *)
        configure_template $*
        ;;
esac
