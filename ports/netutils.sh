#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/netutils.git
DIR=netutils

CARGO_ARGS="--bin wget -- -Z print-link-args -C linker=x86_64-elf-redox-gcc"
CARGO_BINS="dhcpd dns httpd irc nc ntp wget"
cargo_template $*
