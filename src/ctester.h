/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   ctester.h                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: sbos <sbos@student.codam.nl>                 +#+                     */
/*                                                   +#+                      */
/*   Created: 2022/04/20 14:18:07 by sbos          #+#    #+#                 */
/*   Updated: 2022/07/21 11:30:03 by sbos          ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

////////////////////////////////////////////////////////////////////////////////

#ifndef CTESTER_H
# define CTESTER_H

////////////////////////////////////////////////////////////////////////////////

# include "libft.h"
# include "massert.h"

////////////////////////////////////////////////////////////////////////////////

# include "ctester_globals.h"

////////////////////////////////////////////////////////////////////////////////

# include <fcntl.h>		// open
# include <sys/wait.h>	// wait // TODO: include used?

// For Unix
# include <ctype.h>		// isalpha // TODO: include used?
# include <string.h>	// strlcat, strlcpy // TODO: include used?

////////////////////////////////////////////////////////////////////////////////

typedef void (*void_fn)(void);

typedef struct s_fn_info {
	char	*fn_name;
	void_fn	fn_ptr;
}	t_fn_info;

////////////////////////////////////////////////////////////////////////////////

extern t_list	*g_tests_lst;

////////////////////////////////////////////////////////////////////////////////

// TODO: Can these declarations be removed?
t_list	*test_lstnew(void *content);
t_list	*test_lst_new_front(t_list **lst, void *content);

////////////////////////////////////////////////////////////////////////////////

#define Test(name)																\
	void test_##name(void);														\
	__attribute__((constructor))												\
	void add_test_##name(void)													\
	{																			\
		static t_fn_info fn_info = {.fn_name = #name, .fn_ptr = &test_##name};	\
		test_lst_new_front(&g_tests_lst, &fn_info);								\
	}																			\
	void test_##name(void)

////////////////////////////////////////////////////////////////////////////////

#define BeforeMain(name)														\
	__attribute__((constructor))												\
	void before_main_##name(void)

#define AfterMain(name)															\
	__attribute__((destructor))													\
	void after_main_##name(void)

////////////////////////////////////////////////////////////////////////////////

# define test_io_fd(fn, val, ret, on_error, ...)									\
{																					\
	was_malloc_unstable = false;													\
	was_write_unstable = false;														\
	int const	fd = open("/tmp/" #fn "_test", O_RDWR | O_CREAT | O_TRUNC, 0640);	\
	ssize_t	ret_value = fn(val, fd);												\
	if (was_malloc_unstable OR was_write_unstable)									\
	{																				\
		massert(ret_value, (ssize_t)(on_error));									\
	}																				\
	else																			\
	{																				\
		massert(ret_value, (ssize_t)(__VA_ARGS__ + strlen(ret)));					\
		FILE *f = fdopen(fd, "rw");													\
		fseek(f, 0, SEEK_END);														\
		long file_size = ftell(f);													\
		char buf[file_size + 1];													\
		memset(buf, '\0', (size_t)file_size + 1);									\
		lseek(fd, 0, SEEK_SET);														\
		read(fd, buf, (size_t)file_size);											\
		massert(buf, ret);															\
	}																				\
	close(fd);																		\
}

# define test_io(fn, val, ret, on_error, ...)										\
{																					\
	was_malloc_unstable = false;													\
	was_write_unstable = false;														\
	int stdout_fd = dup(STDOUT_FILENO);												\
	int const	fd = open("/tmp/" #fn "_test", O_RDWR | O_CREAT | O_TRUNC, 0640);	\
	dup2(fd, STDOUT_FILENO);														\
	ssize_t	ret_value = fn(val);													\
	dup2(stdout_fd, STDOUT_FILENO);													\
	if (was_malloc_unstable OR was_write_unstable)									\
	{																				\
		massert(ret_value, (ssize_t)(on_error));									\
	}																				\
	else																			\
	{																				\
		massert(ret_value, (ssize_t)(__VA_ARGS__ + strlen(ret)));					\
		FILE *f = fdopen(fd, "rw");													\
		fseek(f, 0, SEEK_END);														\
		long file_size = ftell(f);													\
		char buf[file_size + 1];													\
		memset(buf, '\0', (size_t)file_size + 1);									\
		lseek(fd, 0, SEEK_SET);														\
		read(fd, buf, (size_t)file_size);											\
		massert(buf, ret);															\
	}																				\
	close(fd);																		\
}

////////////////////////////////////////////////////////////////////////////////

#define m_safe_assert(type, input, expected, on_error, reset_unstables)	\
{																		\
	type input_value = input;											\
	if (was_malloc_unstable OR was_write_unstable)						\
	{																	\
		massert(input_value, (type)on_error);							\
	}																	\
	else																\
	{																	\
		massert(input_value, (type)expected);							\
	}																	\
	if (reset_unstables)												\
	{																	\
		was_malloc_unstable = false;									\
		was_write_unstable = false;										\
	}																	\
}

#define m_safe_string_assert(input_str, expected, reset_unstables)\
{\
	m_safe_assert(char *, input_str, expected, NULL, reset_unstables);\
}

#define m_safe_string_assert_free(input_str, expected, reset_unstables)\
{\
	char	*inp = input_str;\
	m_safe_string_assert(inp, expected, reset_unstables);\
	free(inp);\
}

////////////////////////////////////////////////////////////////////////////////

#endif

////////////////////////////////////////////////////////////////////////////////
