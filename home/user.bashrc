#!/bin/bash

alias sudo='sudo env PATH=$PATH'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lll='ls -alh'
alias grep='grep --exclude=tags --color=auto'

##############
## REPO URL ##
##############
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/'

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
