#!/bin/bash
source environ.sh

BROKEN

SRC=http://curl.haxx.se/download/curl-7.45.0.tar.gz
DIR=curl-7.45.0

CONFIGURE_ARGS="--host=${HOST}"
configure_template $*
