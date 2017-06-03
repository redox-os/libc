#!/bin/bash
set -e

ARCH=x86_64
TARGET="${ARCH}-elf-redox"
RUST_TARGET="${ARCH}-unknown-redox"

ROOT="${PWD}"

BUILD="${ROOT}/build"
mkdir -p "${BUILD}"
cd "${BUILD}"

PREFIX="${BUILD}/prefix"
mkdir -p "${PREFIX}"
mkdir -p "${PREFIX}/bin"
export PATH="${PREFIX}/bin:$PATH"

SYSROOT="${BUILD}/sysroot"
mkdir -p "${SYSROOT}"

CROSS="${BUILD}/cross"
mkdir -p "${CROSS}"
cd "${CROSS}"

###################BINUTILS#########################
function binutils {
    BINUTILS="${ROOT}/binutils-gdb"

    rm -rf "binutils"
    mkdir "binutils"
    pushd "binutils"
        "${BINUTILS}/configure" --target="${TARGET}" --prefix="${PREFIX}" --with-sysroot="${SYSROOT}" --disable-gdb --disable-nls --disable-werror
        make -j `nproc`
        make -j `nproc` install
    popd
}

##################GCC FREESTANDING##############################
function gcc_freestanding {
    GCC="${ROOT}/gcc"

    pushd "${GCC}"
        ./contrib/download_prerequisites
    popd

    pushd "${GCC}/libstdc++-v3"
        autoconf2.64
    popd

    rm -rf "gcc-freestanding"
    mkdir "gcc-freestanding"
    pushd "gcc-freestanding"
        "${GCC}/configure" --target="${TARGET}" --prefix="${PREFIX}" --disable-nls --enable-languages=c,c++ --without-headers
        make -j `nproc` all-gcc
        make -j `nproc` all-target-libgcc
        make -j `nproc` install-gcc
        make -j `nproc` install-target-libgcc
    popd
}

##################NEWLIB###########################
function newlib {
    NEWLIB="${ROOT}/newlib"

    echo "Defaulting to rust nightly"
    rustup override set nightly
    echo "Update rust nightly"
    rustup update nightly
    echo "Downloading rust source"
    rustup component add rust-src
    if [ -z "$(which xargo)" ]
    then
        echo "Installing xargo"
        cargo install -f xargo
    fi

    pushd "${NEWLIB}/newlib/libc/sys"
        aclocal-1.11 -I ../..
        autoconf
        automake-1.11 --cygnus Makefile
    popd

    pushd "${NEWLIB}/newlib/libc/sys/redox"
        aclocal-1.11 -I ../../..
        autoconf
        automake-1.11 --cygnus Makefile
    popd

    rm -rf "newlib"
    mkdir "newlib"
    pushd "newlib"
        "${NEWLIB}/configure" --target="${TARGET}" --prefix="${PREFIX}"
        make -j `nproc` all
        make -j `nproc` install
    popd

    mkdir -p "${SYSROOT}/usr"
    cp -r "${PREFIX}/${TARGET}/lib" "${SYSROOT}/usr"
    cp -r "${PREFIX}/${TARGET}/include" "${SYSROOT}/usr"
}

######################GCC############################
function gcc_complete {
    GCC="${ROOT}/gcc"

    rm -rf "gcc"
    mkdir "gcc"
    pushd "gcc"
        "${GCC}/configure" --target="${TARGET}" --prefix="${PREFIX}" --with-sysroot="${SYSROOT}" --disable-nls --enable-languages=c,c++
        make -j `nproc` all-gcc
        make -j `nproc` all-target-libgcc
        make -j `nproc` install-gcc
        make -j `nproc` install-target-libgcc
        make -j `nproc` all-target-libstdc++-v3
        make -j `nproc` install-target-libstdc++-v3
    popd
}

case $1 in
    binutils)
        binutils
        ;;
    gcc_freestanding)
        gcc_freestanding
        ;;
    newlib)
        newlib
        ;;
    gcc_complete)
        gcc_complete
        ;;
    all)
        binutils
        gcc_freestanding
        newlib
        gcc_complete
        ;;
    *)
        echo "$0 [binutils, gcc_freestanding, newlib, gcc_complete, rust, cargo, all]"
        ;;
esac
