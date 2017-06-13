#!/bin/bash
source environ.sh

UNSTABLE
DEPENDS llvm

GIT=https://github.com/ids1024/rust.git
GIT_BRANCH=compile-redox
DIR=rust

unset AR AS CC CXX LD NM OBJCOPY OBJDUMP RANLIB READELF STRIP

export REDOX_LLVM_CONFIG="${BUILD}/${DIR}/llvm-config"

function rustbuild_template {
    case $1 in
        build)
            cp ${BUILD}/../ports/rust/* "${BUILD}/${DIR}"
            pushd "${BUILD}/${DIR}"
            python x.py build
            popd
            ;;
        add)
            fetch_template add
            rustbuild_template build
            rustbuild_template install
            ;;
        install)
            pushd "${BUILD}/${DIR}"
            mkdir -p "${BUILD}/sysroot/{bin,lib}"
            cp -fv "build/${RUST_HOST}/stage2/bin/rustc" "${BUILD}/sysroot/bin"
	    ${HOST}-strip "${BUILD}/sysroot/bin/rustc"
            cp -fv $(find build/${RUST_HOST}/stage2/lib/rustlib/${RUST_HOST}/lib/ -type f | grep -v librustc) "${BUILD}/sysroot/lib"
            popd
            ;;
        *)
            configure_template $*
            ;;
    esac
}

rustbuild_template $*
