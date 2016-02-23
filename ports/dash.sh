#!/bin/bash
source environ.sh

BROKEN

SRC=http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.8.tar.gz
DIR=dash-0.5.8

CONFIGURE_ARGS="--host=i386-elf-redox --prefix=$PREFIX"
configure_template $*
