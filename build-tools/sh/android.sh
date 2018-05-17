#!/bin/bash

# adb screencap
function android_screencap() {
if [ "$1" == "" ]; then
	sd_image="screen.png"
	host_image="/tmp/screen.png"
else
	sd_image=$1
	host_image=$1
fi

pr_info "capture screen --> ${host_image}\n"
adb shell screencap -p /sdcard/${sd_image}
adb pull /sdcard/${sd_image} ${host_image}
eog ${host_image}
}

# android adb push
# $1: source path and destination path, src == dest
# $2: chmod argument
function android_adb_push() {
if (( $# < 2 )); then
	pr_warn "usage: apush path mode\n"
	return
fi
if [ ! -e "$1" ]; then
	pr_err "$1 not exist!\n"
	return
fi
set -x

adb wait-for-device
adb root
adb wait-for-device
adb remount
adb wait-for-device

# redirect stderr to stdout, and piped to awk
# rc=`adb push $1 /$1 2>&1 | awk -F ' ' '{print $1}'`
adb push $1 /$1
adb shell chmod $2 /$1
set +x
adb shell sync
pr_info "ok\n"
}

# msm8909 control
# set gpio register, msmgpio gpio_n reg_n [print|value]
function android_msm_gpio_control() {
if (( $# < 2 )); then
	pr_warn "usage:\n"
	pr_warn "  msmgpio gpio_n reg_n [print|value]\n"
	return
fi
if (( $1 < 0 || $1 > 150)); then
	pr_err "invalid gpio number: $1\n"
	return
fi

if (( $2 != 0 && $2 != 4)); then
	pr_err "invalid register: $2\n"
fi
(( register = 0x01000000 + 0x1000 * $1 + $2 ))
if [ "$3" == "" ]; then
	printf "show 0x%x = " $register
	adb shell busybox devmem $register 32

elif [ "$3" == "print" ]; then
	pr_info "command:\n"
	printf "  busybox devmem 0x%x 32\n" $register

else
	printf "set 0x%x = 0x%x\n" $register $3
	adb shell busybox devmem $register 32 $3
fi
}

# adb wait device
function android_adb_wait_device() {
	adb wait-for-device
}

# android dump a block
# $1: block name will be cloned
# $2: block size will be cloned, in MB
function android_adb_dump_block() {
	if (( $# < 2 )); then
		pr_warn "usage: dumpblk block_name size_in_MB\n"
		return
	fi
	(( size_sectors = $2 * 2048 ))
	pr_info "cloned $1 sectors = $size_sectors\n"

	test -e "$1" && rm $1
	android_adb_wait_device
	adb root
	android_adb_wait_device

	if (( $size_sectors == 0 )); then
		pr_info "erase $1 block\n"
		adb shell dd if=/dev/zero of=/dev/block/bootdevice/by-name/$1 count=2048
	else
		adb shell rm /sdcard/$1
		adb shell dd if=/dev/block/bootdevice/by-name/$1 of=/sdcard/$1 count=$size_sectors
		adb pull /sdcard/$1 .
	fi

	pr_info "ok\n"
}

function android_adb_install() {
	if [ ! -e "$1" ]; then
		pr_err "file: $1 not exist\n"
		return
	fi

	adb install -r $1
}

# @brief send android keyevent
# @param 1:keyname, the key name
function android_adb_input_keyevent() {
	pr_info "keyevent $1\n"
	adb shell input keyevent $1
}

# @brief android adb debug command set
#
# @param subcmd: the adb subcommand
# @param list: the subcommand argument
function android_adb_cmdset() {
	case "$1" in
	"ainstall" )
		android_adb_install $2 ;;
	"kl" )
		android_adb_input_keyevent DPAD_LEFT ;;
	"kr" )
		android_adb_input_keyevent DPAD_RIGHT ;;
	"ku" )
		android_adb_input_keyevent DPAD_UP ;;
	"kd" )
		android_adb_input_keyevent DPAD_DOWN ;;
	"ke" )
		android_adb_input_keyevent ENTER;;
	"kp" )
		android_adb_input_keyevent POWER ;;
	"kb" )
		android_adb_input_keyevent BACK ;;
	"kh" )
		android_adb_input_keyevent HOME ;;
	"kvu" )
		android_adb_input_keyevent VOLUME_UP ;;
	"kvd" )
		android_adb_input_keyevent VOLUME_DOWN ;;
	* )
		pr_err "unknown adb command $1\n" ;;
	esac
}

# @brief adb start app
function android_adb_am_start() {
if [ "$1" == "" ]; then
	echo_err "miss package name"
	return
fi
cstring=$1/$1
if [ "$2" != "" ]; then
	cstring=$cstring.$2
else
	cstring=$cstring".MainActivity"
fi
adb shell am start -n $cstring
}
