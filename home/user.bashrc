#!/bin/bash

alias sudo='sudo env PATH=$PATH'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lll='ls -alh'
alias grep='grep --exclude=tags --color=auto'

TOOLS_PATH=$HOME/tools
LINUXCFG_PATH=$HOME/linuxcfg
LINUXCFG_TOOLS_PATH=$LINUXCFG_PATH/home/tools

# auto completion
. $HOME/linuxcfg/git-completion.bash

#########
## jdk ##
#########
export JAVA_HOME=$LINUXCFG_TOOLS_PATH/jdk/jdk
if [ -n "$JAVA_HOME" ]; then
export CLASSPATH=$JAVA_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH
fi

# arm linux gcc
export PATH=$TOOLS_PATH/arm_tc/bin:$PATH

## PATH env: linuxcfg tools
export PATH=$LINUXCFG_TOOLS_PATH/bin:$PATH
## PATH env: home tools
export PATH=$TOOLS_PATH:$PATH
## PATH env: ndk-build
NDK_PATH=$LINUXCFG_TOOLS_PATH/ndk/bin
export PATH=$NDK_PATH:$PATH

. $LINUXCFG_PATH/fcs/user.bashfc

# cd real directory
function cdre() {
cd `pwd -P`
}

# cd .. until find .repo
# if not found .repo, stay current
function croot() {
cur_path=`pwd`
while [ ! -d .repo ]; do
	now_path=`pwd`
	if [ "$now_path" = "/" ]; then
		echo "not found .repo"
		cd $cur_path
		return
	fi
	cd ..
done
}

