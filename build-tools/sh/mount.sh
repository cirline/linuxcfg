#!/bin/bash

# @1:	mount path
# @2:	data path
function mount_ecryptfs_v2() {
if [ ! -d $1 ]; then mkdir $1; fi
if [ ! -d $2 ]; then mkdir $2; fi

dir_content=`ls $1`
if [ -z "$dir_content" ]; then
	sudo mount -t ecryptfs $2 $1 -o ecryptfs_cipher=aes -o ecryptfs_key_bytes=16 -o ecryptfs_passthrough=n -o ecryptfs_enable_filename_crypto=n
else
	pr_err "$1 not empty\n"
fi
}

# @1:	mount path
function umount_ecryptfs_v2() {
sudo umount -t ecryptfs $1
}

function mount_ecrypt_sync_dir() {
mount_ecryptfs_v2 $ecrypt_sync_dir_mount $ecrypt_sync_dir_data
}

function umount_ecrypt_sync_dir() {
umount_ecryptfs_v2 $ecrypt_sync_dir_mount
}

