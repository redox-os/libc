# Redox Libc and Ports

Newlib, ported to Redox, and a number of shell files for compiling other programs.

[![Travis Build Status](https://travis-ci.org/redox-os/libc.svg?branch=master)](https://travis-ci.org/redox-os/libc)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE.md)

## Building the toolchain and libc

Run `./setup.sh all` to build the gcc toolchain and newlib libc implementation.

Arch Linux and .deb packages can be built from the files in `packages/`. A prebuild .deb toolchain is available at https://static.redox-os.org/toolchain/.

## Building ports

To build a port, enter the ports directory with `cd ports`. Choose a port to build, such as lua, keeping in mind the fact that many of the ports due not work yet. You can then run `./lua.sh add` to build the port. You can then copy the binary `../build/sysroot/usr/bin/lua` to Redox's filesystem.
