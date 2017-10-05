#!/bin/bash
source environ.sh

BROKEN

SRC=http://www.nasm.us/pub/nasm/releasebuilds/2.12.01/nasm-2.12.01.tar.bz2
DIR=nasm-2.12.01

CONFIGURE_ARGS=("--host=${HOST}")
configure_template $*
