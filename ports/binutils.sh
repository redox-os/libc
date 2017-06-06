#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/binutils-gdb.git
DIR=binutils-gdb

CONFIGURE_ARGS="--host=${HOST} --target=${HOST} --prefix=/ --with-sysroot=${SYSROOT} --disable-gdb --disable-nls --disable-werror"

function binutils_template {
    case $1 in
        install)
            make -C "${BUILD}/${DIR}/${MAKE_DIR}" DESTDIR="${BUILD}/sysroot" -j `nproc` install
            ;;
        add)
            fetch_template add
            configure_template configure
            make_template build
            binutils_template install
            ;;
        uninstall)
            make -C "${BUILD}/${DIR}/${MAKE_DIR}" DESTDIR="${BUILD}/sysroot" -j `nproc` uninstal
            ;;
        *)
            configure_template $*
            ;;
    esac
}

binutils_template $*
