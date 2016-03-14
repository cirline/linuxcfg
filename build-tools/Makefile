# 
build_path	:= $(shell pwd)
home_path	:= $$HOME

# function
define tools_inf
@echo "\033[36minfo: \033[0m$(1)"
endef

define tools_err
@echo "\033[31m error:\033[0m $(1)"
endef

# make config file
config_file		:= build.config
defconfig_file	:= build_defconfig.mk
config_exist	:= $(shell if [ -f $(config_file) ]; then echo 1; fi)

ifdef config_exist
include $(config_file)
else
config_error:
	$(tools_err) "cannot find $(config_file)"
	make defconfig
endif

include $(defconfig_file)

build			:= build.out
build_objs		:= build.l

tools_install	:= simple-tools
tools_out		:= $(tools_install).out
tools_config	:= $(tools_install).config
tools_link		:= simple-tools.linkcommand

objs	:=
objs	+= $(tools_config)
objs	+= simple-tools.common
objs	+= simple-tools-misc
objs	+= simple-tools.mount
objs	+= simple-tools.linkcommand
objs	+= simple-tools.rawmode
objs	+= simple-tools-main

dirs	:=
dirs	+= $(out_path)

# begin build
$(tools_out): $(build) $(dirs) $(config_file) $(objs)
	$(build_path)/$(build) $@ $(objs)
	chmod 755 $@
	$(tools_inf) "all finish"

$(dirs):
	$(tools_inf) "checking directory: "
	@if [ ! -d $(out_path) ]; then mkdir $(out_path); fi

$(tools_config): $(config_file)
	$(tools_inf) "create simple-tools config"
	@echo "#!/bin/bash" > $@
	@echo "tools_debug=$(tools_debug)" >> $@
	@echo "efs_data_path=$(efs_data_path)" >> $@
	@echo "efs_mnt_path=$(efs_mnt_path)" >> $@

config: $(config_file)

$(config_file): $(defconfig_file)
	$(tools_inf) "$(defconfig_file) is changed ~ "
	cat $(defconfig_file) >> $(config_file)

defconfig: $(defconfig_file)
	$(tools_inf) "copy default config file: "
	cp $(defconfig_file) $(config_file)

$(build): build.l
	flex -o lex.yy.c $^
	gcc -o $@ lex.yy.c -lfl

distclean:
	make clean
	rm *.config

clean:
	rm *.out lex.yy.c

install:
	cp $(tools_out) $(install_path)/$(tools_install)
	$(install_path)/$(tools_install) clink $(install_path)


