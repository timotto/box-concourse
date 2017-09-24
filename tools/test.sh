#!/bin/sj

PTXC=ci/tools/ptxconf.sh
$PTXC
$PTXC remove a && exit 1 || true
$PTXC set a b && exit 1 || true
