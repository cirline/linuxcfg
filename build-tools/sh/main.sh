#!/bin/bash
#include "sh/misc.sh"
#include "sh/link.sh"
#include "sh/rawmode.sh"
#include "sh/mount.sh"
#include "sh/common.sh"
#include "sh/android.sh"

case $cmd in
"bbshell" | "bbshell.out" )
	simple_tools_raw_mode $* ;;
"dumpblk" )
	android_adb_dump_block $* ;;
"ainstall" )
	android_adb_cmdset install $*;;
"apush" )
	android_adb_push $* ;;
"msmgpio" )
	android_msm_gpio_control $* ;;
"mesd" )
	mount_ecrypt_sync_dir $* ;;
"uesd" )
	umount_ecrypt_sync_dir $* ;;
"lff" )
	misc_linkfiles $* ;;
"scap" )
	android_screencap $* ;;
"ff" )
	misc_start_firfox $* ;;
	"stvar" )
		misc_simpletools_var $* ;;
	"jc_start" )
		misc_jinguoyun_start $* ;;
	* )
		pr_err "unknown command($cmd) !\n" ;;
esac

