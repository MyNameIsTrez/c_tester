# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: sbos <sbos@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2022/02/04 14:13:55 by sbos          #+#    #+#                  #
#    Updated: 2022/07/21 17:11:01 by sbos          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

################################################################################

export CTESTER=1

################################################################################

SOURCES :=\
	src/ctester.c

################################################################################

CTESTER_BINARY := ctester

CC := cc

SRC_DIR := src
OBJ_DIR := obj

CFLAGS := -Wall -Wextra -Werror
CFLAGS += -DSTATIC=
CFLAGS += -g3 -Wconversion

LIBFT_DIR := libft
MASSERT_DIR := libmassert

HEADERS := $(shell $(MAKE) -f headers.mk)

LIB_NAMES :=\
	$(MASSERT_DIR)/libmassert.a\
	$(LIBFT_DIR)/libft.a\
	$(addprefix $(TESTS_DIR)/, $(shell $(MAKE) -C $(TESTS_DIR) get_libs))

################################################################################

ifdef SAN
CFLAGS += -fsanitize=address
endif

# sort removes duplicates
# TODO: Switch around addprefix and sort so it's consistent with the rest of the file.
INCLUDES := $(addprefix -I, $(sort $(dir $(HEADERS))))

# Automatically calls the "clean" rule whenever CFLAGS or SOURCES is changed.
DATA_FILE := .make_data
MAKE_DATA := $(CFLAGS) $(SOURCES)
PRE_RULES :=
ifneq ($(shell echo "$(MAKE_DATA)"), $(shell cat "$(DATA_FILE)" 2> /dev/null))
PRE_RULES += clean
endif

################################################################################

.DEFAULT_GOAL := all

MAKE_LIBFT:
	$(MAKE) -C $(LIBFT_DIR) all

MAKE_MASSERT:
	$(MAKE) -C $(MASSERT_DIR) all

MAKE_TESTS:
	$(MAKE) -C $(TESTS_DIR) all

.PHONY: MAKE_LIBFT MAKE_MASSERT MAKE_TESTS

################################################################################

CTESTER_OBJECTS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SOURCES:.c=.o))

LIB_FLAGS := $(sort $(addprefix -L,$(dir $(LIB_NAMES)))) $(sort $(patsubst lib%,-l%,$(basename $(notdir $(LIB_NAMES)))))

################################################################################

.PHONY: all
all: $(PRE_RULES) $(CTESTER_BINARY)

ifndef TESTS_DIR
$(CTESTER_BINARY):
	$(error TESTS_DIR must be given)
else
$(CTESTER_BINARY): MAKE_LIBFT MAKE_MASSERT MAKE_TESTS $(CTESTER_OBJECTS)
	$(CC) $(CFLAGS) -g3 $(CTESTER_OBJECTS) $(shell find $(TESTS_DIR)/obj/tests -name "*.o") $(LIB_FLAGS) -o $(CTESTER_BINARY)
	@echo "$(MAKE_DATA)" > $(DATA_FILE)
endif

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDES) -g3 -c $< -o $@

################################################################################

.PHONY: clean
clean:
	rm -rf $(OBJ_DIR)

.PHONY: fclean
fclean: clean
	rm -f $(CTESTER_BINARY)
	$(MAKE) -C $(LIBFT_DIR) fclean
	$(MAKE) -C $(MASSERT_DIR) fclean

.PHONY: re
re: fclean all

################################################################################
