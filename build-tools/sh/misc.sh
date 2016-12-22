#!/bin/bash

function misc_simpletools_var() {
case $1 in
"jcloud_path" )
	echo $jcloud_path ;;
"efs_mnt_path" )
	echo $efs_mnt_path ;;
* )
	if [ ! "$1" = "help" ] && [ ! "$1" = "" ]; then
		pr_err "not define ($1)\n"
	fi
	printf "echo Simple Tools VARibles\n"
	printf "usage: $(split_filename $0) [varible|help], all valid varible:\n"
	printf "%20s = %s\n" "efs_mnt_path" $efs_mnt_path
	printf "%20s = %s\n" "jcloud_path" $jcloud_path
	;;
esac
}

function misc_jinguoyun_start() {
if [ ! -e $jcloud_path ]; then
	pr_err "jcloud dir not found\n"
	return
fi
pr_info "start nutstore daemon...\n"
python $HOME/.nutstore/dist/bin/nutstore-pydaemon.py
}

