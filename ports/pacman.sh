#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/ebuc99/pacman.git
DIR=pacman

AUTOGEN_ARGS="--host=${HOST} --prefix=$PREFIX --with-sdl-prefix=$PREFIX --disable-sdltest"
autogen_template $*
