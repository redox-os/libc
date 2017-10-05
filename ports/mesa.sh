#!/bin/bash
source environ.sh

BROKEN

SRC=https://mesa.freedesktop.org/archive/12.0.1/mesa-12.0.1.tar.gz
DIR=mesa-12.0.1

export PTHREADSTUBS_CFLAGS="."
export PTHREADSTUBS_LIBS="."
CONFIGURE_ARGS=("--host=${HOST}" "--disable-gles1" "--disable-gles2" "--disable-dri" "--disable-dri3" "--disable-glx" "--disable-egl" "--disable-driglx-direct" "--enable-gallium-osmesa" "--with-gallium-drivers=swrast" "--disable-llvm-shared-libs")
configure_template $*
