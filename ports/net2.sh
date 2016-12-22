#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/redox-os/net2-rs.git
DIR=net2-rs

CARGO_BINS=""
cargo_template $*
