#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/webpki.git
DIR=webpki

CARGO_BINS=""
cargo_template $*
