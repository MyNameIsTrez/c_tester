mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(mkfile_dir)/libft/Makefile

LIBFT_DIR := libft
MASSERT_DIR := libmassert

LIBCTESTER_HEADERS =\
	$(addprefix libft/, $(HEADERS))\
	$(MASSERT_DIR)/massert.h\
	src/unstable/libft_unstable.h\
	src/ctester.h

.PHONY: get_headers
get_headers:
	@echo $(LIBCTESTER_HEADERS)

.DEFAULT_GOAL := get_headers
