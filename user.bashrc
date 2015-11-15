#!/bin/bash

alias sudo='sudo env PATH=$PATH'
alias lll='ls -alF'
alias grep='grep --exclude=tags --color=auto'

# java
export JAVA_HOME=/home/chenqiwei/adata_home/ch/tools/jdk1.6.0_38
export CLASSPATH=$JAVA_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH

# arm linux gcc
export PATH=/home/chenqiwei/tools/toolchain-4.3.2/bin:$PATH

# tools
export PATH=$HOME/tools:$PATH
