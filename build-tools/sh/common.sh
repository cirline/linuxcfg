#!/bin/bash

# split directory from path
function split_directory() {
path=$1
filename=$(split_filename $path)
fn_length=${#filename}
path_length=${#path}
((directory_length = $path_length - $fn_length))
directory=${path:0:$directory_length}
echo $directory
}

function dir_deep() {
path=$1
deep=`echo $path | awk -F '/' '{print NF}'`
first=`echo $path | awk -F '/' '{print $1}'`
if [ "$first" = "" ]; then
	((deep -= 2))
else
	((deep -= 1))
fi
echo $deep
}

