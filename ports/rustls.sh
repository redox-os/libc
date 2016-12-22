#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/rustls.git
DIR=rustls

CARGO_ARGS="--no-default-features"
CARGO_BINS=""
cargo_template $*
