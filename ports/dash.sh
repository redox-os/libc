#!/bin/bash
source environ.sh

BROKEN

SRC=http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.8.tar.gz
DIR=dash-0.5.8

CONFIGURE_ARGS="--host=${HOST} --prefix=$PREFIX"
configure_template $*
