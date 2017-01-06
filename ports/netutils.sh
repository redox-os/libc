#!/bin/bash
source environ.sh

UNSTABLE

GIT=https://github.com/redox-os/netutils.git
DIR=netutils

CARGO_BINS="dhcpd dns httpd irc nc ntp wget"
cargo_template $*
