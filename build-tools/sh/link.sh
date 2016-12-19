#!/bin/bash

# link the quick command to simple-tools

# create the symbolic link to simple-tools,
# for use a short command to start simple-tools
function create_symbolic_link_all() {
# misc commands
do_link comment_line	" ** MISC Commands\n"
do_link stvar		"echo simple-tools variable"
do_link jc_start	"start nutstore daemon"
do_link comment_line	" ** \n"
}

