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

out_path	?= $(build_path)/bin

tools	:= simple-tools

objs	:=
objs	+= simple-tools_defconfig
objs	+= simple-tools-main

# begin build
$(tools): config
	$(tools_inf) "build simple-tools, out: $(out_path)"
	@if [ ! -d $(out_path) ]; then mkdir $(out_path); fi
	cat $(objs) > $(out_path)/$@
	chmod +x $(out_path)/$@
	$(tools_inf) "all finish"

config: $(config_file)

$(config_file): $(defconfig_file)
	$(tools_inf) "$(defconfig_file) is changed ~ "
	cat $(defconfig_file) >> $(config_file)

defconfig: $(defconfig_file)
	$(tools_inf) "copy default config file: "
	cp $(defconfig_file) $(config_file)

distclean:
	rm *.config

