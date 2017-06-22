#!/bin/bash

# link the quick command to simple-tools

# create or remove the soft symlink to simple-tools
# the soft symlink is a quick command to start simple-tools
# **
# $1:
#   help or ' ': print the help message
#   remove:      remove the soft link
#   else:        create the soft link
# $2:
#   install path
function link_create_symbolic_all() {
if [[ $1 == "" || $1 == "help" ]]; then
	print_help=1
	echo "Bbusybox for shell(bbshell), usage:"
elif [[ $1 == "remove" ]]; then
	link_remove_flag=1
	pr_warn "remove all symbolic links\n"
fi

installpath=$2

do_link_all

# misc commands
do_link comment_line	" -- MISC Commands --\n"
do_link stvar		"echo simple-tools variable"
do_link jc_start	"start nutstore daemon"
do_link lff		"link file to fsave directory"
do_link ff		"start firefox -p $firefox_profile"
do_link comment_line	"\n"

# mount Commands
do_link comment_line	" -- MOUNT Commands --\n"
do_link mesd		"mount jcould ecrypt sync dir"
do_link uesd		"umount jcould ecrypt sync dir"

# android
do_link	comment_line	" -- A N D R O I D --\n"
do_link msmgpio		"msm gpio control"
do_link dumpblk		"android dump block, eg: dumpblk klog 2222"

do_link	comment_line	" -- A N D R O I D (ADB) --\n"
do_link apush		"adb push, usage: apush path mode"
do_link ainstall	"v01, adb install, usage: ainstall file_path"
}

# remove all the symlink to simple-tools
function link_remove_all() {
link_create_symbolic_all remove $2
}

