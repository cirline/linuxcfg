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

function misc_linkfiles() {
if (( $# < 1 )); then
	pr_err "missing argument\n"
	return;
fi
path=$1
dir=$(split_directory $path)
dir="./fsave/$dir"
if [ ! -e $dir ]; then
	pr_warn "$dir not exist, make it\n"
	mkdir -p $dir
fi
deep=$(dir_deep $path)
prefix=""
for((i = 0; i <= $deep; i++)); do
	prefix="../$prefix"
done
pr_info "deep = $deep, prefix=$prefix\n"
cd $dir
ln -s $prefix/$path .
cd -
}

