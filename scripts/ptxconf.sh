#!/bin/sh -e

ptxc_setup() { 
	ptxv=$(ptxdist --version | sed -e's/\.[0-9]*$//')
	rcfile="${HOME}/.ptxdist/ptxdistrc-${ptxv}"
}

ptxc_ptxconf() { 
	rcfile=./selected_ptxconfig
}

ptxc_remove() { 
	assert_rcfile
	sed -i "$rcfile" -es"/^${1}=.*$//"
}

ptxc_add() { 
	assert_rcfile
	echo "${1}=\"${2}\"" >> "$rcfile"
}

assert_rcfile() {
	[ -n "$rcfile" ] || fail "setup or ptxdist?"
	[ -f "$rcfile" ] || fail "config file not found"
}

fail() {
	echo "$@"
	exit 1
}

while [ -n "$1" ]; do case "$1" in
  setup) 			ptxc_setup 												;;
  ptxconfig) 		ptxc_ptxconf 											;;
  set) 				shift; ptxc_remove "$1" ; ptxc_add "$1" "$2" ; shift 	;;
  remove) 			shift; ptxc_remove "$1" 								;;
  *) 				fail "Invalid argument: $1"								;;
esac ; shift ; done
