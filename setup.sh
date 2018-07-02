#!/usr/bin/env bash
set -e

ARCH=x86_64
export TARGET="${ARCH}-unknown-redox"

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

    echo "Defaulting to rust nightly"
    rustup override set nightly-2018-04-27
    echo "Downloading rust source"
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

for cmd in autoconf,2.64 automake,1.11 aclocal,1.11; do
    # how to split an unquoted string
    IFS=","
    # set assigns any arguments to $1, $2, etc
    set -- $cmd
    if ! hash $1 &> /dev/null; then
        echo "Must install $1 version $2 before x86_64-unknown-redox may be built"
        exit 1
    fi
    if [[ "$(eval $1 --version 2>/dev/null | head -n1 | cut -d' ' -f4)" != "$2"* ]]; then
        echo "$1 is installed, but version isn't $2."
        echo "Make sure the correct version is in \$PATH"
        exit 1
    fi
done

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
