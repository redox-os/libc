#!/bin/bash
source environ.sh

BROKEN

SRC=http://http.debian.net/debian/pool/main/d/dash/dash_0.5.8.orig.tar.gz
DIR=dash-0.5.8

CONFIGURE_ARGS=("--host=${HOST}")
autoconf_template $*
