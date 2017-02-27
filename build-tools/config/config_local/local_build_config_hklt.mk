# makefile

install_path ?= $(home_path)/tools

out_path ?= $(build_path)/out

tools_debug ?= 7

efs_data_path ?= /opt/.d41d8cd98f00b204e9800998ecf8427e

efs_mnt_path ?= /home/e

android_phone_setting ?= $(home_path)/.android_phone_setting

do_before_leaving_config ?= $(home_path)/.file.list

ct_path ?= $(efs_mnt_path)/code-test

jcloud_path ?= $(efs_mnt_path)/.jcloud

ecrypt_sync_dir_mount ?= $(home_path)/je

ecrypt_sync_dir_data ?= /home/chqw/vbox/.jedata

firefox_profile ?= def

