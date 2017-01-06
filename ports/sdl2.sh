#!/bin/bash
source environ.sh

GIT=https://github.com/redox-os/SDL-mirror.git
GIT_BRANCH=redox
DIR=SDL-mirror

CONFIGURE_ARGS="--host=${HOST} --disable-shared --disable-pulseaudio --disable-video-x11 \
    --disable-ime --disable-loadso --disable-sdl-dlopen --disable-threads --disable-timers \
    --enable-audio --enable-dummyaudio --enable-video --enable-video-orbital"
autogen_template $*
