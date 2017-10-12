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

function misc_jianguoyun_start() {
if [ ! -e $jcloud_path ]; then
	pr_err "jcloud dir $jcloud_path not found\n"
	return
fi
jc_bin=${jcloud_bin}/dist/bin/nutstore-pydaemon.py
pr_info "start nutstore daemon ${jc_bin} ...\n"
python ${jc_bin}
}

# symlink: lff
function misc_linkfiles() {
if (( $# < 1 )); then
	pr_err "link source file to ./fsave/ directory - \n"
	pr_err "missing argument\n"
	pr_err "arg1: source file\n"
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
#pr_info "deep = $deep, prefix=$prefix\n"
cd $dir
set -x
ln -s $prefix/$path .
set +x
#cd -
}

# start firefox
function misc_start_firfox() {
pr_info "start firefox -p $firefox_profile\n"
firefox -p $firefox_profile
}

# make_tags	- make tags
function misc_make_tags() {

ctags -I __THROW \
	--file-scope=yes \
	--langmap=c:+.h \
	--languages=c,c++ \
	--links=yes \
	--c-kinds=+p \
	--fields=+S  \
	-R /usr/include .
}

