# makefile
# default configure file
#
# build 
# install_path was be fixed and don't change it
# install_path		?= $(home_path)/tools

out_path		?= $(build_path)/out

# tools set
# tools debug
tools_debug		?= 0

# tools run
efs_data_path	?= $(out_path)/efsdata
efs_mnt_path	?= $(out_path)/efsmnt

# android
android_phone_setting	?= $(home_path)/.android_phone_setting

# file delete
do_before_leaving_config	?= $(home_path)/.file.list

# code test path
ct_path		?= /opt/e/code-test

# jianguoyun sync path
jcloud_path	?= $(home_path)/jcloud

# ecryptfs sync dir
ecrypt_sync_dir_mount	?= /opt/e/jedata
ecrypt_sync_dir_data	?= /opt/e/jlocal/edata

# firefox profile
firefox_profile		?= def

