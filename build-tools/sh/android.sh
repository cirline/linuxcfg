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

