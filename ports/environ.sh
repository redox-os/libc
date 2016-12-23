#!/bin/bash
set -e

name="$(basename "$0" .sh)"

ARCH="x86_64"
HOST="${ARCH}-elf-redox"
RUST_HOST="${ARCH}-unknown-redox"
BUILD="$(dirname "${PWD}")/build"
PREFIX="${BUILD}/sysroot/usr"
export PATH="${BUILD}/prefix/bin:$PATH"
export PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig/"
export AR="${HOST}-ar"
export AS="${HOST}-as"
export CC="${HOST}-gcc"
export CXX="${HOST}-g++"
export CONFIGURE=./configure
export LD="${HOST}-ld"
export NM="${HOST}-nm"
export OBJCOPY="${HOST}-objcopy"
export OBJDUMP="${HOST}-objdump"
export RANLIB="${HOST}-ranlib"
export READELF="${HOST}-readelf"
export STRIP="${HOST}-strip"

function BROKEN {
    printf "%-16s \e[1m\e[31mBROKEN\e[39m\e[0m\n" "$name"
}

function UNSTABLE {
    printf "%-16s \e[1m\e[33mUNSTABLE\e[39m\e[0m\n" "$name"
}

function STABLE {
    printf "%-16s \e[1m\e[32mSTABLE\e[39m\e[0m\n" "$name"
}

function DEPENDS {
    for depend in $*
    do
        printf "%-16s \e[1m%s\e[0m\n" "$name" "$depend"
    done
}

function fetch_template {
    case $1 in
        add)
            fetch_template fetch
            if [ -f "$name.patch" ]
            then
	        patch -p1 -d "${BUILD}/${DIR}" < "$name.patch"
            fi
            ;;
        remove)
            if [ -d "${BUILD}/${DIR}" ]
            then
                rm -rfv "${BUILD}/${DIR}"
            fi
            ;;
        fetch)
            if [ -n "${SRC}" ]
            then
                if [ ! -f "${BUILD}/$(basename "${SRC}")" ]
                then
                    wget "${SRC}" -O "${BUILD}/$(basename "${SRC}")"
                fi
                rm -rf "${BUILD}/${DIR}"
                pushd "${BUILD}"
                tar xf "$(basename "${SRC}")"
                popd
            elif [ -n "${GIT}" ]
            then
                if [ ! -d "${BUILD}/${DIR}" ]
                then
                    pushd "${BUILD}"
                    if [ -n "${GIT_BRANCH}" ]
                    then
                        git clone --recursive "${GIT}" --branch "${GIT_BRANCH}"
                    else
                        git clone --recursive "${GIT}"
                    fi
                    popd
                else
                    pushd "${BUILD}/${DIR}"
                    git clean -fd
                    git reset --hard
                    git pull
                    popd
                fi
            fi
            ;;
        unfetch)
            if [ -n "${SRC}" ]
            then
                if [ -f "${BUILD}/$(basename "${SRC}")" ]
                then
                    rm -fv "${BUILD}/$(basename "${SRC}")"
                fi
            elif [ -n "${GIT}" ]
            then
                if [ -d "${BUILD}/${DIR}" ]
                then
                    rm -rfv "${BUILD}/${DIR}"
                fi
            fi
            ;;
        patch)
            if [ -f "${BUILD}/${DIR}/$2" ]
            then
                mkdir -pv "$(dirname "${DIR}/$2")"
                cp -v "${BUILD}/${DIR}/$2" "${DIR}/$2"
            fi
            ;;
    esac
}

function make_template {
    case $1 in
        build)
            make -C "${BUILD}/${DIR}/${MAKE_DIR}" -j `nproc` $BUILD_ARGS
            ;;
        install)
            make -C "${BUILD}/${DIR}/${MAKE_DIR}" -j `nproc` install $INSTALL_ARGS
            ;;
        add)
            fetch_template add
            make_template build
            make_template install
            ;;
        clean)
            make -C "${BUILD}/${DIR}/${MAKE_DIR}" -j `nproc` clean $CLEAN_ARGS
            ;;
        uninstall)
            make -C "${BUILD}/${DIR}/${MAKE_DIR}" -j `nproc` uninstall $UNINSTALL_ARGS
            ;;
        remove)
            make_template uninstall || true
            make_template clean || true
            fetch_template remove
            ;;
        *)
            fetch_template $*
            ;;
    esac
}

function cargo_template {
    case $1 in
        update)
            pushd "${BUILD}/${DIR}/${MAKE_DIR}"
            cargo update
            popd
            ;;
        build)
            pushd "${BUILD}/${DIR}/${MAKE_DIR}"
            which rustc
            cargo rustc --target="${RUST_HOST}" --release --verbose $CARGO_ARGS
            popd
            ;;
        install)
            if [ -n "${CARGO_BINS}" ]
            then
                for bin in ${CARGO_BINS}
                do
                    cp -v "${BUILD}/${DIR}/${MAKE_DIR}/target/${RUST_HOST}/release/$bin" "${PREFIX}/bin"
                done
            fi
            ;;
        add)
            fetch_template add
            cargo_template build
            cargo_template install
            ;;
        clean)
            pushd "${BUILD}/${DIR}/${MAKE_DIR}"
            cargo clean
            popd
            ;;
        uninstall)
            if [ -n "${CARGO_BINS}" ]
            then
                for bin in ${CARGO_BINS}
                do
                    rm -v "${PREFIX}/bin/$bin"
                done
            fi
            ;;
        remove)
            cargo_template uninstall || true
            cargo_template clean || true
            fetch_template remove
            ;;
        *)
            fetch_template $*
            ;;
    esac
}

function configure_template {
    case $1 in
        configure)
            pushd "${BUILD}/${DIR}/${MAKE_DIR}"
            ${CONFIGURE} --prefix="${PREFIX}" $CONFIGURE_ARGS
            popd
            ;;
        add)
            fetch_template add
            configure_template configure
            make_template build
            make_template install
            ;;
        distclean)
            make -C "${BUILD}/${DIR}/${MAKE_DIR}" -j `nproc` distclean $DISTCLEAN_ARGS
            ;;
        remove)
            make_template uninstall || true
            configure_template distclean || true
            fetch_template remove
            ;;
        *)
            make_template $*
            ;;
    esac
}

function autoconf_template {
    case $1 in
        autoconf)
            pushd "${BUILD}/${DIR}/${MAKE_DIR}"
                autoconf $AUTOCONF_ARGS
            popd
            ;;
        add)
            fetch_template add
            autoconf_template autoconf
            configure_template configure
            make_template build
            make_template install
            ;;
        *)
            configure_template $*
            ;;
    esac
}

function autogen_template {
    case $1 in
        autogen)
            pushd "${BUILD}/${DIR}"
                ./autogen.sh $AUTOGEN_ARGS
            popd
            ;;
        add)
            fetch_template add
            autogen_template autogen
            configure_template configure
            make_template build
            make_template install
            ;;
        *)
            configure_template $*
            ;;
    esac
}
