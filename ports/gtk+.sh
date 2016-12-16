#!/bin/bash
source environ.sh

BROKEN

SRC=http://ftp.gnome.org/pub/gnome/sources/gtk+/3.19/gtk+-3.19.1.tar.xz
DIR=gtk+-3.19.1

CONFIGURE_ARGS="--host=${TARGET} --prefix=$PREFIX"
configure_template $*
