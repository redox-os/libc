#!/bin/bash
source environ.sh

BROKEN

SRC=http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.26.tar.bz2
DIR=tcc-0.9.26

CONFIGURE_ARGS="--prefix=$PREFIX --cross-prefix=i386-elf-redox- --crtprefix=/lib"
configure_template $*
