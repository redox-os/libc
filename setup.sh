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

######################RUST############################
function rust {
    RUST="${ROOT}/rust"

    #rm -rf "rust"
    mkdir -p "rust"
    pushd "rust"
cat > config.toml <<-EOF
        [llvm]
        ccache = true

        [build]
        target = ["${RUST_TARGET}"]
        docs = false
        submodules = false

        [install]
        prefix = "${PREFIX}"

        [rust]
        codegen-units = 0
        codegen-tests = false
        use-jemalloc = false

        [target.${RUST_TARGET}]
        cc = "${TARGET}-gcc"
        cxx = "${TARGET}-g++"
EOF
        "${RUST}/x.py" build -j `nproc`
        "${RUST}/x.py" dist -j `nproc`
        "${RUST}/x.py" dist --install -j `nproc`
        build/tmp/dist/rust-std-1.16.0-dev-x86_64-unknown-redox/install.sh --prefix="${PREFIX}"
    popd
}

######################Cargo###########################
function cargo {
    CARGO="${ROOT}/cargo"

    #rm -rf "cargo"
    mkdir -p "cargo"
    pushd "cargo"
        "${CARGO}/configure" --prefix="${PREFIX}"
        make -j `nproc`
        make install -j `nproc`
    popd
}

######################RUST############################
function rust_host {
    RUST="${ROOT}/rust"

    #rm -rf "rust_host"
    mkdir -p "rust_host"
    pushd "rust_host"
cat > config.toml <<-EOF
        [llvm]
        ccache = true

        [build]
        host = ["${RUST_TARGET}"]
        target = ["${RUST_TARGET}"]
        docs = false
        submodules = false

        [install]
        prefix = "${SYSROOT}"

        [rust]
        codegen-units = 0
        codegen-tests = false
        use-jemalloc = false

        [target.${RUST_TARGET}]
        cc = "${TARGET}-gcc"
        cxx = "${TARGET}-g++"
EOF
        "${RUST}/x.py" build -j `nproc`
        "${RUST}/x.py" dist -j `nproc`
        "${RUST}/x.py" dist --install -j `nproc`
        build/tmp/dist/rust-std-1.16.0-dev-x86_64-unknown-redox/install.sh --prefix="${SYSROOT}"
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
    rust)
        rust
        ;;
    cargo)
        cargo
        ;;
    rust_host)
        rust_host
        ;;
    all)
        binutils
        gcc_freestanding
        newlib
        gcc_complete
        rust
        cargo
        ;;
    *)
        echo "$0 [binutils, gcc_freestanding, newlib, gcc_complete, rust, cargo, all]"
        ;;
esac
