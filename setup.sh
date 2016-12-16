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
        "${BINUTILS}/configure" --target="${TARGET}" --prefix="${PREFIX}" --with-sysroot="${SYSROOT}" --disable-nls --disable-werror
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
        #make -j `nproc` all-target-libstdc++-v3
        #make -j `nproc` install-target-libstdc++-v3
    popd
}

######################OpenLIBM############################
function openlibm {
    OPENLIBM="${ROOT}/openlibm"
    CC="${TARGET}-gcc" CFLAGS=-fno-stack-protector make -C "${OPENLIBM}" libopenlibm.a
    cp -v "${OPENLIBM}/libopenlibm.a" "${PREFIX}/lib"
}

######################RUST############################
function rust {
    RUST="${ROOT}/rust"

    rm -rf "rust"
    mkdir "rust"
    pushd "rust"
cat > config.toml <<-EOF
        [build]
        target = ["x86_64-unknown-redox"]
        [rust]
        codegen-units = 0
        use-jemalloc = false
EOF
        "${RUST}/x.py" build -j `nproc` --stage 1
        "${RUST}/x.py" dist -j `nproc` --keep-stage 1
        build/tmp/dist/rustc-1.15.0-dev-x86_64-unknown-linux-gnu/install.sh --prefix="${PREFIX}" --verbose
        build/tmp/dist/rust-std-1.15.0-dev-x86_64-unknown-linux-gnu/install.sh --prefix="${PREFIX}" --verbose
        build/tmp/dist/rust-std-1.15.0-dev-x86_64-unknown-redox/install.sh --prefix="${PREFIX}" --verbose
    popd "rust"
}

#####################RUST CRATES##########################
function rust_crates {
    OUT_DIR="${PREFIX}/lib/rustlib/x86_64-unknown-redox/lib"
    rustc --target="${RUST_TARGET}" -C opt-level=2 -C debuginfo=0 --crate-type rlib --crate-name syscall "${ROOT}/syscall/src/lib.rs" --out-dir "${OUT_DIR}"
    rustc --target="${RUST_TARGET}" -C opt-level=2 -C debuginfo=0 --crate-type rlib --crate-name ralloc --cfg 'feature="allocator"' "${ROOT}/ralloc/src/lib.rs" --out-dir "${OUT_DIR}"
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
    openlibm)
        openlibm
        ;;
    rust)
        rust
        ;;
    rust_crates)
        rust_crates
        ;;
    all)
        binutils
        gcc_freestanding
        newlib
        gcc_complete
        openlibm
        rust
        rust_crates
        ;;
    *)
        echo "$0 [binutils, gcc_freestanding, newlib, gcc_complete, openlibm, rust, rust_crates, all]"
        ;;
esac
