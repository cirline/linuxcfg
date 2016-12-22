#!/bin/bash
#include "sh/misc.sh"
#include "sh/link.sh"
#include "sh/rawmode.sh"

case $cmd in
"simple-tools" | "simple-tools.out" )
	simple_tools_raw_mode $* ;;
	"stvar" )
		misc_simpletools_var $* ;;
	"jc_start" )
		misc_jinguoyun_start $* ;;
	* )
		pr_err "unknown command($cmd) !\n" ;;
esac

