#!/bin/sh -e

dpkg -i ptxdist-root-bucket/*deb
dpkg -i toolchain-bucket/*deb

/opt/OSELAS.Toolchain-${TOOLCHAIN}*/${TARGET}/gcc-*/bin/${TARGET}-gcc \
	-o test \
	ci/toolchain/test.c

file test
