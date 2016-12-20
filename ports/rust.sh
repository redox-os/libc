#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/redox-os/rust.git
GIT_BRANCH=redox_cross
DIR=rust

CONFIGURE_ARGS="--host=${RUST_HOST} --disable-jemalloc"
configure_template $*
