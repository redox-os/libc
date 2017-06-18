#!/bin/bash
source environ.sh

UNSTABLE
DEPENDS llvm

GIT=https://github.com/ids1024/rust.git
GIT_BRANCH=compile-redox
DIR=rust

unset AR AS CC CXX LD NM OBJCOPY OBJDUMP RANLIB READELF STRIP

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
            binpath="${BUILD}/sysroot/bin"
            libpath="${BUILD}/sysroot/lib/rustlib/${RUST_HOST}/lib"
            mkdir -p "$binpath" "$libpath"
            cp -fv "build/${RUST_HOST}/stage2/bin/rustc" "$binpath"
            ${HOST}-strip "$binpath/rustc"
            cp -fv $(find build/${RUST_HOST}/stage2/lib/rustlib/${RUST_HOST}/lib/ -type f | grep -v librustc) "$libpath"
            popd
            ;;
        *)
            configure_template $*
            ;;
    esac
}

rustbuild_template $*
