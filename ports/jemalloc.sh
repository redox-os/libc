#!/bin/bash
source environ.sh

BROKEN

SRC=https://github.com/jemalloc/jemalloc/releases/download/4.1.0/jemalloc-4.1.0.tar.bz2
DIR=jemalloc-4.1.0

CONFIGURE_ARGS="--host=i386-elf-redox --prefix=$PREFIX"
configure_template $*
