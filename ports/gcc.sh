#!/bin/bash
source environ.sh

BROKEN

SRC=http://ftp.gnu.org/gnu/gcc/gcc-4.6.4/gcc-4.6.4.tar.bz2
DIR=gcc-4.6.4

CONFIGURE_ARGS="--host=${HOST} --target=${HOST}"

case $1 in
    add)
        fetch_template add
        pushd "${BUILD}/${DIR}"
        ./contrib/download_prerequisites
        cp config.sub libjava/classpath/config.sub
        cp config.sub gmp/configfsf.sub
        cp config.sub mpc/config.sub
        cp config.sub mpfr/config.sub
        cp config.sub mpc/config.sub
        popd
        configure_template configure
        make_template build
        make_template install
        ;;
    *)
        configure_template $*
        ;;
esac
