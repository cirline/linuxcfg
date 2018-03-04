#######################
## busybox for shell ##
#######################

install_bin	:= bbshell

build_path	:= $(shell pwd)
home_path	:= $(shell echo $$HOME)
install_path	:= $(home_path)/linuxcfg/home/tools/bin

export build_path
export home_path

config_path	:= config

# function
echo_info	= @echo -e "\033[34m $(1) \033[0m"
echo_err	= @echo -e "\033[31m $(1) \033[0m"
echo_success	= @echo -e "\033[32m $(1) \033[0m"
pr_info		= @echo -e "\033[34m $(1) \033[0m"
export pr_info

# config file
make_config		:= local_build_config_autocreate.mk
stools_config_makefile	:= shconfig_create_autocreate.mk
stools_config		:= stools_local_config_autocreate.sh
defconfig_file		:= config/build_defconfig.mk
make_config_exist	:= $(shell if [ -f $(config_file) ]; then echo 1; fi)

export make_config
export stools_config_makefile
export stools_config


ifdef make_config_exist
include $(config_path)/$(make_config)
else
config_error:
	$(call echo_err, "cannot find $(config_path)/$(make_config)")
	make config
endif

#include $(defconfig_file)

build			:= build.out
build_objs		:= build.l

# build config tool
build_config_tool	:= bconfig.out
bctool-objs	:= btools/bconfig.l


tools_install	:= $(install_bin)
tools_out	:= $(tools_install).out
ui_install	:= $(tools_install).ui
ui_out		:= $(ui_install).out

objs	:= $(config_path)/$(stools_config)
objs	+= simple-tools.common
objs	+= simple-tools.misc
objs	+= mount.sh
objs	+= simple-tools.linkcommand
objs	+= simple-tools.android
objs	+= customization.sh
objs	+= sh/main.sh
objs	+= sh/misc.sh
objs	+= sh/link.sh
objs	+= sh/rawmode.sh
objs	+= sh/mount.sh
objs	+= sh/common.sh
objs	+= sh/android.sh

mobj	:= simple-tools.main

ui_objs := simple-tools.wxui

dirs	:= $(out_path)

all: $(tools_out) $(ui_out)
	$(call echo_success, "all finish")

onekey:
	make
	make install
	$(call echo_success, "onekey make finish")

# begin build
$(tools_out): $(build) $(dirs) $(config_file) $(objs) $(mobj)
	$(build_path)/$(build) $@ $(mobj)
	chmod 755 $@
	$(call echo_success, "make $(tools_out) success")

$(ui_out): $(ui_objs)
	$(build_path)/$(build) $@ $(ui_objs)
	chmod 755 $@
	$(call echo_success, "make $(ui_out) success")

$(dirs):
	$(call echo_info, "checking directory")
	@if [ ! -d $(out_path) ]; then mkdir $(out_path); fi

config: $(config_path)/$(stools_config)

$(config_path)/$(stools_config): $(config_path)/$(make_config) $(build_config_tool)
	$(call pr_info, "make config change ~")
	$(call pr_info, "rebuild $@")
	make -C config dest_out=$(stools_config) src_in=$(make_config)

$(config_path)/$(make_config): $(defconfig_file) $(build_config_tool)
	$(call pr_info, "default config change ~")
	$(call pr_info, "rebuild $@")
	@if [ ! -e $@ ]; then cp $(defconfig_file) $@; fi
	@mv $@ $@~
	@$(build_path)/$(build_config_tool) mkconfig $@ $@~ $(defconfig_file)
	@$(build_path)/$(build_config_tool) shconfigmk $(config_path)/$(stools_config_makefile) $@ $(defconfig_file)

$(build): build.l
	flex -o $@_lex.yy.c $^
	gcc -o $@ $@_lex.yy.c -lfl

$(build_config_tool): $(bctool-objs)
	flex -o $@_lex.yy.c $^
	gcc -o $@ $@_lex.yy.c -lfl

distclean:
	make clean
	rm *.config

clean:
	rm *.out *lex.yy.c

install:
	cp $(tools_out) $(install_path)/$(tools_install)
	$(install_path)/$(tools_install) clink $(install_path)
	cp $(ui_out) $(install_path)/$(ui_install)

uninstall:
	$(install_path)/$(tools_install) remove_link $(install_path)
	rm $(install_path)/$(ui_install)
	rm $(install_path)/$(tools_install)

.PHONY: all onekey config distclean clean install \
	uninstall

