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

# java
#export JAVA_HOME=/home/chenqiwei/adata_home/ch/tools/jdk1.6.0_38
#export CLASSPATH=$JAVA_HOME/lib
#export PATH=$JAVA_HOME/bin:$PATH

# arm linux gcc
export PATH=$TOOLS_PATH/arm_tc/bin:$PATH

# tools
export PATH=$TOOLS_PATH:$LINUXCFG_TOOLS:$PATH

###############
##  Android  ##
###############
NDK_PATH=$LINUXCFG_TOOLS_PATH/ndk/bin
export PATH=$NDK_PATH:$PATH

. $LINUXCFG_PATH/fcs/user.bashfc

# cd real directory
function cdre() {
cd `pwd -P`
}

# configure window pkg-config
# export PKG_CONFIG_PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig
export PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/bin:$PATH
