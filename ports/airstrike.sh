#!/bin/bash
source environ.sh

UNSTABLE

SRC=http://icculus.org/airstrike/airstrike-pre6a-src.tar.gz
DIR=airstrike-pre6a-src

export OPTIONS="-Os -static"
make_template $*
