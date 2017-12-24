
$(info build_path		= $(build_path))
$(info home_path		= $(home_path))
$(info make config		= $(make_config))
$(info stools_config_makefile	= $(stools_config_makefile))

include $(make_config)

all: $(dest_out)

include $(stools_config_makefile)

clean:
	$(call pr_info, "clean ..")

.PHONY: clean

