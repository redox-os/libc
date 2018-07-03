#!/usr/bin/env bash
set -e

action="$1"

ARCH=x86_64
export TARGET="${ARCH}-unknown-redox"
RUST_VERSION=nightly-2018-06-19

ROOT="${ROOT:-$PWD}"

if [ `uname` = "Darwin" ]; then
    NPROC=`sysctl -n hw.ncpu`
    NO_VERIFY="--no-verify"
    AUTOCONF="autoconf264"
    AUTOMAKE="automake112"
    ACLOCAL="aclocal112"
else
    NPROC=`nproc`
    AUTOCONF="autoconf2.64"
    # Autoconf is often autoconf<version> or autoconf-<version>
    if ! hash $AUTOCONF &> /dev/null; then
        AUTOCONF="autoconf-2.64"
        if ! hash $AUTOCONF &> /dev/null; then
            AUTOCONF="autoconf"
        fi
    fi
    AUTOMAKE="automake-1.11"
    if ! hash $AUTOMAKE &> /dev/null; then
        AUTOMAKE="automake"
    fi
    ACLOCAL="aclocal-1.11"
    if ! hash $ACLOCAL &> /dev/null; then
        ACLOCAL="aclocal"
    fi
fi

BUILD="${ROOT}/build"
mkdir -p "${BUILD}"
cd "${BUILD}"

PREFIX=${PREFIX:-"${BUILD}/prefix"}
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
        make -j $NPROC
        make -j $NPROC install
    popd
}

##################GCC FREESTANDING##############################
function gcc_freestanding {
    GCC="${ROOT}/gcc"

    pushd "${GCC}"
        ./contrib/download_prerequisites $NO_VERIFY
    popd

    pushd "${GCC}/libstdc++-v3"
        $AUTOCONF
    popd

    rm -rf "gcc-freestanding"
    mkdir "gcc-freestanding"
    pushd "gcc-freestanding"
        "${GCC}/configure" --target="${TARGET}" --prefix="${PREFIX}" --disable-nls --enable-languages=c,c++ --without-headers
        make -j $NPROC all-gcc
        make -j $NPROC all-target-libgcc
        make -j $NPROC install-gcc
        make -j $NPROC install-target-libgcc
    popd
}

##################NEWLIB###########################
function newlib {
    NEWLIB="${ROOT}/newlib"

    echo "Setting Rust version to ${RUST_VERSION}"
    rustup override set "${RUST_VERSION}"
    echo "Downloading Rust source"
    rustup component add rust-src
    if [ -z "$(which xargo)" ]
    then
        echo "Installing xargo"
        cargo install -f xargo
    fi

    pushd "${NEWLIB}/newlib/libc/sys"
        $ACLOCAL -I ../..
        autoconf
        $AUTOMAKE --cygnus Makefile
    popd

    pushd "${NEWLIB}/newlib/libc/sys/redox"
        $ACLOCAL -I ../../..
        autoconf
        $AUTOMAKE --cygnus Makefile
    popd

    rm -rf "newlib"
    mkdir "newlib"
    pushd "newlib"
        "${NEWLIB}/configure" --target="${TARGET}" --prefix="${PREFIX}" --enable-newlib-iconv
        make -j $NPROC all
        make -j $NPROC install
    popd

    mkdir -p "${SYSROOT}/usr"
    cp -r "${PREFIX}/${TARGET}/lib" "${SYSROOT}/usr"
    cp -r "${PREFIX}/${TARGET}/include" "${SYSROOT}/usr"
}

##################NEWLIB###########################
function relibc {
    RELIBC="${ROOT}/relibc"

    echo "Setting Rust version to ${RUST_VERSION}"
    rustup override set "${RUST_VERSION}"
    echo "Adding Redox OS target"
    rustup target add "${TARGET}"
    echo "Downloading Rust source"
    rustup component add rust-src

    rm -rf "relibc"
    cp -r "${RELIBC}" "relibc"
    pushd "relibc"
        make -j $NPROC all
        make -j $NPROC "DESTDIR=${PREFIX}/${TARGET}" install
        make -j $NPROC "DESTDIR=${SYSROOT}/usr" install
    popd
}

######################GCC############################
function gcc_complete {
    GCC="${ROOT}/gcc"

    rm -rf "gcc"
    mkdir "gcc"
    pushd "gcc"
        "${GCC}/configure" --target="${TARGET}" --prefix="${PREFIX}" --with-sysroot="${SYSROOT}" --disable-nls --enable-languages=c,c++
        make -j $NPROC all-gcc
        make -j $NPROC all-target-libgcc
        make -j $NPROC install-gcc
        make -j $NPROC install-target-libgcc
        make -j $NPROC all-target-libstdc++-v3
        make -j $NPROC install-target-libstdc++-v3
    popd
}

for pair in $AUTOCONF,2.64 $AUTOMAKE,1.11 $ACLOCAL,1.11
do
    cmd="$(echo "$pair" | cut -d "," -f 1)"
    ver="$(echo "$pair" | cut -d "," -f 2)"
    if ! hash $cmd &> /dev/null; then
        echo "Must install $cmd version $ver before x86_64-unknown-redox may be built"
        exit 1
    fi
    if [[ "$(eval $cmd --version 2>/dev/null | head -n1 | cut -d' ' -f4)" != "$ver"* ]]; then
        echo "$cmd is installed, but version isn't $ver."
        echo "Make sure the correct version is in \$PATH"
        exit 1
    fi
done

case "$action" in
    binutils)
        binutils
        ;;
    gcc_freestanding)
        gcc_freestanding
        ;;
    newlib)
        newlib
        ;;
    relibc)
        relibc
        ;;
    gcc_complete)
        gcc_complete
        ;;
    all)
        binutils
        gcc_freestanding
        newlib
        # TODO: relibc
        gcc_complete
        ;;
    *)
        echo "$0 [binutils, gcc_freestanding, newlib, relibc, gcc_complete, all]"
        ;;
esac
