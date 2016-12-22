#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/time.git
DIR=time

CARGO_BINS=""
cargo_template $*
