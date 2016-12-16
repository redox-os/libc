#!/bin/bash
source environ.sh

UNSTABLE

SRC=https://www.openssl.org/source/openssl-1.1.0c.tar.gz
DIR=openssl-1.1.0c

CONFIGURE="./Configure"
CONFIGURE_ARGS="--prefix=${PREFIX} no-shared redox-x86_64"
configure_template $*
