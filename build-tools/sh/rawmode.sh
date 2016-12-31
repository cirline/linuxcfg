#!/bin/bash

function simple_tools_raw_mode() {
pr_debug "raw mode, args number = $#"

case $1 in
"clink" | "")
	do_link_all $@
	create_symbolic_link_all $*
	;;
esac
}

