#!/bin/bash
source environ.sh

UNSTABLE
DEPENDS sdl
DEPENDS sdl_image

SRC=http://icculus.org/airstrike/airstrike-pre6a-src.tar.gz
DIR=airstrike-pre6a-src

export OPTIONS="-Os -static"
make_template $*
