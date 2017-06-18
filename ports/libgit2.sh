#!/bin/bash
source environ.sh

UNSTABLE

SRC=https://github.com/libgit2/libgit2/archive/v0.25.1.tar.gz
DIR=libgit2-0.25.1
CMAKE_ARGS=(-DCMAKE_CROSSCOMPILING=True -DCMAKE_SYSTEM_NAME=Generic -target=$HOST -DTHREADSAFE=Off -DCURL=Off -DUSE_SSH=Off -DBUILD_CLAR=Off -DCMAKE_INSTALL_PREFIX="$PREFIX")

cmake_template $*
