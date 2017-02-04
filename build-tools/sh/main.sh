#!/bin/bash
#include "sh/misc.sh"
#include "sh/link.sh"
#include "sh/rawmode.sh"
#include "sh/mount.sh"
#include "sh/common.sh"
#include "sh/android.sh"

case $cmd in
"simple-tools" | "simple-tools.out" )
	simple_tools_raw_mode $* ;;
"mesd" )
	mount_ecrypt_sync_dir $* ;;
"uesd" )
	umount_ecrypt_sync_dir $* ;;
"lff" )
	misc_linkfiles $* ;;
"scap" )
	android_screencap $* ;;
	"stvar" )
		misc_simpletools_var $* ;;
	"jc_start" )
		misc_jinguoyun_start $* ;;
	* )
		pr_err "unknown command($cmd) !\n" ;;
esac

