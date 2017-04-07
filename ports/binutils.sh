#!/bin/bash
source environ.sh

BROKEN
DEPENDS libiconv

GIT=https://github.com/redox-os/binutils-gdb.git
DIR=binutils-gdb

CONFIGURE_ARGS="--host=${HOST} --disable-gdb --disable-nls"
configure_template $*
