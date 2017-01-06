#!/bin/bash
source environ.sh

BROKEN

GIT=https://github.com/redox-os/mesa.git
GIT_BRANCH=redox
DIR=mesa

CONFIGURE_ARGS="--host=${HOST} --enable-osmesa --disable-driglx-direct --disable-dri --disable-egl --disable-glx --disable-gbm --disable-omx"
AUTOGEN_ARGS="${CONFIGURE_ARGS}"
autogen_template $*
