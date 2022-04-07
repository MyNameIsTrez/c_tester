# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: sbos <sbos@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2022/02/04 14:13:55 by sbos          #+#    #+#                  #
#    Updated: 2022/04/07 18:23:19 by sbos          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

################################################################################

SOURCES :=								\
	src/unstable/ft_unstable_malloc.c	\
	src/unstable/ft_unstable_write.c

################################################################################

NAME := libctester.a

CC := cc

SRC_DIR := src
OBJ_DIR := obj

CFLAGS := -Wall -Wextra -Werror

HEADERS :=

################################################################################

FCLEANED_FILES := $(NAME)

# DEBUG is set to 1 when tester.mk includes this file
ifdef DEBUG
ifdef NO_STATIC
CFLAGS += -DSTATIC=
endif
CFLAGS += -g3 -Wconversion
CFLAGS += -Wno-nullability-completeness # Needed for intercepting stdlib.h
endif

ifdef SAN
CFLAGS += -fsanitize=address
endif

OBJECT_PATHS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(SOURCES:.c=.o))

# sort removes duplicates
INCLUDES := $(addprefix -I, $(sort $(dir $(HEADERS))))

# Only cleans when MAKE_DATA changes.
DATA_FILE := .make_data
MAKE_DATA := $(CFLAGS) $(SOURCES)
PRE_RULES :=
ifneq ($(shell echo "$(MAKE_DATA)"), $(shell cat "$(DATA_FILE)" 2> /dev/null))
PRE_RULES += clean
endif

################################################################################

all: $(PRE_RULES) $(NAME)

$(NAME): $(OBJECT_PATHS)
	ar rcs $(NAME) $(OBJECT_PATHS)
	@echo "$(MAKE_DATA)" > $(DATA_FILE)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

bonus: all

debug:
	@$(MAKE) DEBUG=1 all

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(FCLEANED_FILES)

re: fclean all

################################################################################

.PHONY: all debug clean fclean re

################################################################################
