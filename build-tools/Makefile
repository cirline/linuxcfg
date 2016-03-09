# 
build_path	:= $(shell pwd)

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

tools_install	:= simple-tools
tools_out		:= $(tools_install).out

objs	:=
objs	+= simple-tools_defconfig
objs	+= simple-tools-help
objs	+= simple-tools-main

dirs	:=
dirs	+= $(out_path)

# begin build
$(tools_out): $(dirs) $(config_file) $(objs)
	cat $(objs) > $@
	chmod +x $@
	$(tools_inf) "all finish"

$(dirs):
	$(tools_inf) "checking directory: "
	@if [ ! -d $(out_path) ]; then mkdir $(out_path); fi

config: $(config_file)

$(config_file): $(defconfig_file)
	$(tools_inf) "$(defconfig_file) is changed ~ "
	cat $(defconfig_file) >> $(config_file)

defconfig: $(defconfig_file)
	$(tools_inf) "copy default config file: "
	cp $(defconfig_file) $(config_file)

distclean:
	rm *.config

clean:
	rm *.out

install:
	cp $(tools_out) $(install_path)/$(tools_install)

