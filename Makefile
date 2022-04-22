# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: sbos <sbos@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2022/02/04 14:13:55 by sbos          #+#    #+#                  #
#    Updated: 2022/04/22 18:35:22 by sbos          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

export DEBUG=1

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

CFLAGS := -Wall -Wextra -Werror -Wno-nullability-completeness

LIBFT_DIR := libft
MASSERT_DIR := libmassert

HEADERS := $(shell $(MAKE) -f headers.mk)

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

CTESTER_OBJECTS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SOURCES:.c=.o))

################################################################################

.DEFAULT_GOAL := all

MAKE_LIBFT:
	$(MAKE) -C $(LIBFT_DIR) all

MAKE_MASSERT:
	$(MAKE) -C $(MASSERT_DIR) all

MAKE_TESTS:
	$(MAKE) -C to_test all

.PHONY: MAKE_LIBFT MAKE_MASSERT MAKE_TESTS

################################################################################

all: $(PRE_RULES) $(CTESTER_BINARY)

$(CTESTER_BINARY): MAKE_LIBFT MAKE_MASSERT MAKE_TESTS $(CTESTER_OBJECTS)
	$(CC) $(CFLAGS) -g3 $(CTESTER_OBJECTS) $(wildcard to_test/obj/tests/**/*.o) $(LIB_FLAGS) -o $(CTESTER_BINARY)
	@echo "$(MAKE_DATA)" > $(DATA_FILE)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@mkdir -p $(@D)
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
	$(MAKE) -C $(LIBFT_DIR) fclean
	$(MAKE) -C $(MASSERT_DIR) fclean

re: fclean all

.PHONY: bonus debug clean fclean re

################################################################################
