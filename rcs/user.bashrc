#!/bin/bash

alias sudo='sudo env PATH=$PATH'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lll='ls -alh'
alias grep='grep --exclude=tags --color=auto'

TOOLS_PATH=$HOME/tools
LINUXCFG_PATH=$HOME/linuxcfg

# auto completion
. $HOME/linuxcfg/git-completion.bash

# java
#export JAVA_HOME=/home/chenqiwei/adata_home/ch/tools/jdk1.6.0_38
#export CLASSPATH=$JAVA_HOME/lib
#export PATH=$JAVA_HOME/bin:$PATH

# arm linux gcc
export PATH=$TOOLS_PATH/arm_tc/bin:$PATH

# tools
export PATH=$TOOLS_PATH:$PATH

# android
NDK_HOME=$TOOLS_PATH/ndk
export PATH=$NDK_HOME:$PATH

. $LINUXCFG_PATH/fcs/user.bashfc
