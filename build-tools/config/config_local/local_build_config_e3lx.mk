# makefile

install_path ?= $(home_path)/tools

out_path ?= $(build_path)/out

tools_debug ?= 7

efs_data_path ?= $(out_path)/efsdata

efs_mnt_path ?= $(home_path)/work

android_phone_setting ?= $(home_path)/.android_phone_setting

do_before_leaving_config ?= $(home_path)/.file.list

ct_path ?= /opt/e/code-test

jcloud_path ?= $(home_path)/jcloud

ecrypt_sync_dir_mount ?= $(home_path)/mnt/safe

#ecrypt_sync_dir_data ?= $(home_path)/ddat/local/jcloud/jdisk/backup/encrypt_data/
ecrypt_sync_dir_data ?= $(home_path)/work/bbk/crystore

firefox_profile ?= def

