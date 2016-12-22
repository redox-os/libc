#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/redox-os/mio.git
DIR=mio

CARGO_ARGS="--no-default-features"
CARGO_BINS=""
cargo_template $*
