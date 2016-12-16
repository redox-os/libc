#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/ring.git
DIR=ring

CARGO_ARGS="--no-default-features --features use_heap --example checkdigest"
CARGO_BINS=""
cargo_template $*
