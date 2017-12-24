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
"kl" | "kr" | "ku" | "kd" | "ke" | "ainstall" | "kh" | "kb" | "kp" | "kvu" | "kvd" )
	android_adb_cmdset $cmd $* ;;
"dumpblk" )
	android_adb_dump_block $* ;;
"apush" )
	android_adb_push $* ;;
"msmgpio" )
	android_msm_gpio_control $* ;;
"amstart" )
	android_adb_am_start $* ;;
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
"jc_start" )
	misc_jianguoyun_start $* ;;
"mktags" )
	misc_make_tags $*;;
"stvar" )
	misc_simpletools_var $* ;;
* )
	pr_err "unknown command($cmd) !\n" ;;

esac

