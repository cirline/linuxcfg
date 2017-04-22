#!/bin/bash

# adb screencap
function android_screencap() {
if [ "$1" == "" ]; then
	image="screen.png"
else
	image=$1
fi

pr_info "capture screen --> $image\n"
adb shell screencap -p /sdcard/$image
adb pull /sdcard/$image .
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

adb wait-for-device
adb root
adb wait-for-device
adb remount
adb wait-for-device

# redirect stderr to stdout, and piped to awk
rc=`adb push $1 /$1 2>&1 | awk -F ' ' '{print $1}'`
adb shell chmod $2 /$1
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
	adb shell rm /sdcard/$1
	adb shell dd if=/dev/block/bootdevice/by-name/$1 of=/sdcard/$1 count=$size_sectors
	adb pull /sdcard/$1 .

	pr_info "ok\n"
}

