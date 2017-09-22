#!/bin/bash
source environ.sh

STABLE

SRC=http://zlib.net/zlib-1.2.11.tar.gz
DIR=zlib-1.2.11

CONFIGURE_ARGS="--static"
configure_template $*
