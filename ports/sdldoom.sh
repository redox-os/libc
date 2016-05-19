#!/bin/bash
source environ.sh

UNSTABLE
DEPENDS sdl

SRC=https://www.libsdl.org/projects/doom/src/sdldoom-1.10.tar.gz
DIR=sdldoom-1.10

CONFIGURE_ARGS="--host=${HOST} --prefix=${PREFIX} --disable-sdltest"
configure_template $*
