#!/bin/bash
source environ.sh

SRC=https://www.libsdl.org/release/SDL-1.2.15.tar.gz
DIR=SDL-1.2.15

CONFIGURE_ARGS="--host=${HOST} --disable-shared --disable-pulseaudio --disable-video-x11 \
    --disable-cdrom --disable-loadso --disable-threads --disable-timers \
    --enable-audio --enable-dummyaudio --enable-video-orbital"
autogen_template $*
