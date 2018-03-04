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
pr_info "mounting ${ecrypt_sync_dir_data} --> ${ecrypt_sync_dir_mount}\n"
mount_ecryptfs_v2 $ecrypt_sync_dir_mount $ecrypt_sync_dir_data
}

function umount_ecrypt_sync_dir() {
umount_ecryptfs_v2 $ecrypt_sync_dir_mount
}


# mount sshfs
function mount_sshfs_do() {

username=$1
host=$2
port=$3
remote_dir=$4
local_dir=$5

if [ ! -d ${local_dir} ]; then
    mkdir ${local_dir}
fi

echo "mount ${remote_dir} -> ${local_dir}"
if [ "${username}" = "NC" ]; then
	sshfs ${host}:${remote_dir} ${local_dir} -p ${port}
else
	sshfs ${username}@${host}:${remote_dir} ${local_dir} -p ${port}
fi
}

function mount_sshfs() {

cmd=$1
host=$2
port=$3

case ${cmd} in
	"mtmx" )
		if [ "${host}" = "" ]; then
			pr_err "need ip\n"
			return
		fi
		mount_sshfs_do NC ${host} 8022 "/data/data/com.termux/files/home" "${HOME}/mnt/mtmx"
		;;
	* )
		pr_err "sshfs mount fail, ${cmd}\n" ;;
esac
}
