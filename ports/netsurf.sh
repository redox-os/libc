#!/bin/bash
source environ.sh

BROKEN
DEPENDS expat

SRC=http://download.netsurf-browser.org/netsurf/releases/source-full/netsurf-all-3.3.tar.gz
DIR=netsurf-all-3.3

BUILD_ARGS=("HOST=${HOST}" "PREFIX=${PREFIX}" "TARGET=framebuffer" "Q=" "VQ=" "CCOPT=-I ${PREFIX}/include -Wno-pedantic -Wno-undef")
make_template $*
