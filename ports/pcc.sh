#!/bin/bash
source environ.sh

BROKEN

SRC=http://pcc.ludd.ltu.se/ftp/pub/pcc/pcc-20160603.tgz
DIR=pcc-20160603

CONFIGURE_ARGS="--host=${HOST} --prefix=$PREFIX"
configure_template $*
