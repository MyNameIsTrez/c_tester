# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    headers.mk                                         :+:    :+:             #
#                                                      +:+                     #
#    By: sbos <sbos@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2022/07/25 14:13:36 by sbos          #+#    #+#                  #
#    Updated: 2022/07/25 14:26:55 by sbos          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

################################################################################

mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(mkfile_dir)/libft/Makefile

################################################################################

# LIBCTESTER_HEADERS :=\
# 	$(addprefix libft/, $(HEADERS))\
# 	$(MASSERT_DIR)/massert.h\
# 	src/ctester_globals.h\
# 	src/ctester.h

LIBCTESTER_HEADERS :=\
	src/ctester_globals.h

################################################################################

LIBCTESTER_INCLUDES_HEADERS :=\
	libft/libft.h\
	libmassert/massert.h\
	src/ctester.h

################################################################################

LIBCTESTER_HEADERS += $(LIBCTESTER_INCLUDES_HEADERS)

################################################################################

.PHONY: get_headers
get_headers:
	@echo $(addprefix $(HOME)/Documents/Programming/libctester/, $(LIBCTESTER_HEADERS))

.PHONY: get_includes_headers
get_includes_headers:
	@echo $(addprefix $(HOME)/Documents/Programming/libctester/, $(LIBCTESTER_INCLUDES_HEADERS))

# @echo $(LIBCTESTER_HEADERS)

################################################################################
