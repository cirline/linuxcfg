#!/bin/bash

# this section deal the mount action

# mount_samba - monut a samba directory
# @1: samba server
# @2: remote directory
# @3: local directory
# @4: server username
# @5: server password
function mount_samba() {
if [ ! -d $4 ]; then
	mkdir $4
fi

if [ -z "$5" ]; then
	auth="username=$4"
else
	auth="username=$4,password=$5"
fi

sudo mount -t cifs -o $auth //$1/$2 $3
}

# usage: sshfs_mount username host remotepath locatepath
function sshfs_mount() {
if [ ! -d $4 ]; then
    mkdir $4
fi

echo "mount $3 -> $4"
sshfs $1@$2:$3 $4
}

function sshfs_mount_group() {
case $1 in
    "m241" )
        sshfs_mount chenqiwei 192.168.0.241 /media/workspace2/chenqiwei /home/chqw/mnt/m241
        ;;
    * )
        echo "unknown sshfs mount command: $1"
        ;;
esac
}

# umount_ecryptfs - umount ecryptfs dir
# @efs_mnt_path: umount path
function umount_ecryptfs() {
sudo umount -t ecryptfs $efs_mnt_path
}

# mount_ecryptfs - mount ecryptfs
# @efs_data_path: ecrypt data path
# @efs_mnt_path: mount path
function mount_ecryptfs() {
if [ ! -d $efs_data_path ]; then mkdir $efs_data_path; fi
if [ ! -d $efs_mnt_path ]; then mkdir $efs_mnt_path; fi

dir_content=`ls $efs_mnt_path`
if [ -z "$dir_content" ]; then
	sudo mount -t ecryptfs $efs_data_path $efs_mnt_path -o ecryptfs_cipher=aes -o ecryptfs_key_bytes=16 -o ecryptfs_passthrough=n -o ecryptfs_enable_filename_crypto=y
else
	pr_err "$efs_mnt_path not empty\n"
fi
}

