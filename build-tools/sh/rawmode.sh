#!/bin/bash

function simple_tools_raw_mode() {
pr_debug "raw mode, args number = $#"

case $1 in
"remove_link" )
	link_remove_all $* ;;
"clink" | "")
	create_symbolic_link_all $*
	;;
esac
}

