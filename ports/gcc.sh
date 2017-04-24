#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/redox-os/gcc.git
GIT_BRANCH=redox
DIR=gcc

CONFIGURE_ARGS="--host=${HOST} --target=${HOST} --prefix=/usr --enable-static --disable-shared --disable-dlopen --disable-nls --enable-languages=c --without-headers"
BUILD_ARGS="all-gcc all-target-libgcc"

case $1 in
    add)
        fetch_template add
        pushd "${BUILD}/${DIR}"
        ./contrib/download_prerequisites
	cp config.sub gmp/config.sub
	cp config.sub isl/config.sub
	cp config.sub mpfr/config.sub
	cp -f config.sub mpc/config.sub
        pushd libstdc++-v3
        autoconf2.64
        popd
        popd
        configure_template configure
        make_template build
        make -C "${BUILD}/${DIR}/${MAKE_DIR}" DESTDIR="${BUILD}/sysroot" -j `nproc` install-gcc install-target-libgcc
        ;;
    install)
        make -C "${BUILD}/${DIR}/${MAKE_DIR}" DESTDIR="${BUILD}/sysroot" -j `nproc` install-gcc install-target-libgcc
        ;;
    *)
        configure_template $*
        ;;
esac
