#!/bin/bash

alias sudo='sudo env PATH=$PATH'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lll='ls -alh'
alias grep='grep --exclude=tags --color=auto'

# auto completion
. $HOME/linuxcfg/git-completion.bash

# java
#export JAVA_HOME=/home/chenqiwei/adata_home/ch/tools/jdk1.6.0_38
#export CLASSPATH=$JAVA_HOME/lib
#export PATH=$JAVA_HOME/bin:$PATH

# arm linux gcc
export PATH=/home/chenqiwei/tools/toolchain-4.3.2/bin:$PATH

# tools
export PATH=$HOME/tools:$PATH
export PATH=$HOME/linuxcfg/bin:$PATH
