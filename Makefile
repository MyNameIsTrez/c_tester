# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: sbos <sbos@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2022/02/04 14:13:55 by sbos          #+#    #+#                  #
#    Updated: 2022/04/21 16:54:35 by sbos          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

################################################################################

SOURCES :=								\
	src/unstable/ft_unstable_malloc.c	\
	src/unstable/ft_unstable_write.c	\
	src/ctester.c

################################################################################

CTESTER_BINARY := ctester

CC := cc

SRC_DIR := src
OBJ_DIR := obj

CFLAGS := -Wall -Wextra -Werror

LIBFT_DIR := libft
MASSERT_DIR := libmassert

HEADERS :=						\
	$(LIBFT_DIR)/libft.h		\
	$(MASSERT_DIR)/massert.h

LIB_NAMES :=					\
	$(LIBFT_DIR)/libft.a		\
	$(MASSERT_DIR)/libmassert.a

################################################################################

# DEBUG is set to 1 when tester.mk includes this file
ifdef DEBUG
CFLAGS += -DSTATIC=
CFLAGS += -g3 -Wconversion
CFLAGS += -Wno-nullability-completeness # Needed for intercepting stdlib.h
endif

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

LIB_FLAGS := $(sort $(addprefix -L,$(dir $(LIB_NAMES)))) $(sort $(patsubst lib%,-l%,$(basename $(notdir $(LIB_NAMES)))))

################################################################################

TESTS_SRC_DIR := ../tests
TESTS_OBJ_DIR := ../tests_obj

TESTS_SOURCES := $(wildcard $(TESTS_SRC_DIR)/**/*.c) $(TESTS_SRC_DIR)/tester.c
TESTS_OBJECTS := $(patsubst $(TESTS_SRC_DIR)/%,$(TESTS_OBJ_DIR)/%,$(TESTS_SOURCES:.c=.o))

TESTS_HEADERS :=			\
	../tests/libft_tests.h	\
	src/ctester.h


TESTS_INCLUDES := $(sort $(addprefix -I, $(dir $(TESTS_HEADERS))))

TESTER_LIB_FLAGS := $(sort $(addprefix -L,$(dir $(TESTER_LIB_NAMES)))) $(sort $(patsubst lib%,-l%,$(basename $(notdir $(TESTER_LIB_NAMES)))))

################################################################################

.DEFAULT_GOAL := all

CTESTER_OBJECT_PATHS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SOURCES:.c=.o))

MAKE_LIBFT:
	$(MAKE) -C $(LIBFT_DIR) all

MAKE_MASSERT:
	$(MAKE) -C $(MASSERT_DIR) all

$(TESTS_OBJ_DIR)/%.o: $(TESTS_SRC_DIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(TESTS_INCLUDES) -c $< -o $@

.PHONE: MAKE_LIBFT MAKE_MASSERT

################################################################################

all: $(PRE_RULES) MAKE_LIBFT MAKE_MASSERT $(TESTS_OBJECTS) $(CTESTER_OBJECT_PATHS) $(CTESTER_BINARY)

$(CTESTER_BINARY):
	$(CC) $(CFLAGS) $(TESTER_INCLUDES) -g3 $(TESTS_OBJECTS) $(TESTER_LIB_FLAGS) -o $(CTESTER_BINARY)
	@echo "$(MAKE_DATA)" > $(DATA_FILE)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@mkdir -p $(@D)
# TODO: $(LIB_FLAGS) can't be passed to compiler, only linker!
	$(CC) $(CFLAGS) $(INCLUDES) -g3 -c $< -o $@

.PHONY: all

################################################################################

bonus: all

debug:
	@$(MAKE) DEBUG=1 all

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(CTESTER_BINARY)
	rm -rf ../$(TESTS_OBJ_DIR)
	$(MAKE) -C $(LIBFT_DIR) fclean
	$(MAKE) -C $(MASSERT_DIR) fclean

re: fclean all

.PHONY: bonus debug clean fclean re

################################################################################
