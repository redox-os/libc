#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/redox-os/rust.git
GIT_BRANCH=args_fix
DIR=rust

CONFIGURE_ARGS="--host=${RUST_HOST} --disable-jemalloc"
configure_template $*
