adb wait-for-device
adb shell input keyevent HOME
adb remount;
adb wait-for-device;

#adb push ov5640.ko /vendor/modules/; adb shell chmod 644 /vendor/modules/ov5640.ko

#adb push ar0543_xc6131.ko /vendor/modules/; adb shell chmod 644 /vendor/modules/ar0543_xc6131.ko

koname=ar0543.ko; adb push ${koname} /vendor/modules/; adb shell chmod 644 /vendor/modules/${koname};

adb push vfe_io.ko /vendor/modules/
adb shell chmod 644 /vendor/modules/vfe_io.ko
adb push vfe_v4l2.ko /vendor/modules/
adb shell chmod 644 /vendor/modules/vfe_v4l2.ko

#adb shell rmmod vfe_v4l2
#adb shell rmmod ov5640 
#adb shell insmod /system/vendor/modules/ov5640.ko
#adb shell insmod /system/vendor/modules/vfe_v4l2.ko
#adb reboot
