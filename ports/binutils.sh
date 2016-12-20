#!/bin/bash
source environ.sh

BROKEN

SRC=ftp://sourceware.org/pub/binutils/snapshots/binutils-2.24.90.tar.bz2
DIR=binutils-2.24.90

CONFIGURE_ARGS="--host=${HOST}"
configure_template $*
