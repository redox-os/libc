#!/bin/bash
source environ.sh

UNSTABLE

SRC=http://curl.haxx.se/download/curl-7.45.0.tar.gz
DIR=curl-7.45.0

CONFIGURE_ARGS=("--host=${HOST}" "--disable-tftp" "--disable-ftp")
configure_template $*
