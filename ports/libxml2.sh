#!/bin/bash
source environ.sh

UNSTABLE

SRC=ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz
DIR=libxml2-2.9.2

CONFIGURE_ARGS="--host=${TARGET} --prefix=$PREFIX --without-ftp --without-http --without-python"
configure_template $*
