#!/bin/bash
source environ.sh

BROKEN

SRC=http://ftp.gnu.org/gnu/tar/tar-1.28.tar.xz
DIR=tar-1.28

CONFIGURE_ARGS=("--host=${HOST}")
configure_template $*
