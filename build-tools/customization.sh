#!/bin/bash

# szhklt_custom_cases - szhklt_custom cases
# @1: case name
function szhklt_custom_cases() {
case $1 in
	"s240" )
		mount_samba 192.168.0.240 temp_software $HOME/mnt/s240 szhklt_001 szhklt001
		;;
	"help" | * )
		pr_info "usage: hk help|s240" ;;
esac
}
