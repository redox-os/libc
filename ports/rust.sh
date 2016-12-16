#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/rust-lang/rust.git
DIR=rust

CONFIGURE_ARGS="--host=${HOST} --prefix=$PREFIX"
configure_template $*
