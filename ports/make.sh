#!/bin/bash
source environ.sh

BROKEN

SRC=http://ftp.gnu.org/gnu/make/make-4.2.tar.gz

DIR=make-4.2

CONFIGURE_ARGS="CFLAGS=-DPOSIX --host=${HOST} --without-guile"
configure_template $*
