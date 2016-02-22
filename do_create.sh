#!/bin/bash

dir_home=$HOME
dir_this=`pwd`
dir_backup=$dir_this/.backup

function backup_file() {
file=`echo $1 | awk -F '/' '{print $NF}'`
echo "backup file: $file ..."
if [ ! -d $dir_backup ]; then
    mkdir $dir_backup
fi
cp $1 $dir_backup/$file"_"`date +%Y%m%d%H%M%S`
}

function check_file() {
if [ -f $1 ]; then
echo "file  $1 exist, backup it!"
backup_file $1
rm -rf $1
fi
}

function do_main() {
check_file $2
echo "link: $1 --> $2"
ln -s $1 $2
}

function do_vim() {
echo "do vimrc ..."
do_main $dir_this/user.vimrc $dir_home/.vimrc
}

