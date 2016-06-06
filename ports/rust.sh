#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/rust-lang/rust.git
DIR=rust

CONFIGURE_ARGS="--host=i386-elf-redox --prefix=$PREFIX"
configure_template $*
