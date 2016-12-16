#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/jackpot51/pixelcannon.git
DIR=pixelcannon

CARGO_BINS="pixelcannon"
cargo_template $*
