/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   ctester.c                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: sbos <sbos@student.codam.nl>                 +#+                     */
/*                                                   +#+                      */
/*   Created: 2022/02/05 17:07:20 by sbos          #+#    #+#                 */
/*   Updated: 2022/07/21 16:22:34 by sbos          ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

////////////////////////////////////////////////////////////////////////////////

#include "ctester.h"

////////////////////////////////////////////////////////////////////////////////

int malloc_call_count = 0;
int malloc_call_count_to_fail = 0;
bool was_malloc_unstable = 0;

int write_call_count = 0;
int write_call_count_to_fail = 0;
bool was_write_unstable = 0;

////////////////////////////////////////////////////////////////////////////////

t_list *g_tests_lst = NULL;

////////////////////////////////////////////////////////////////////////////////

// This function has to be redefined here cause it normally calls ft_malloc
// and that could prevent tests from being run.
t_list	*test_lstnew(void *content)
{
	t_list	*lst;

	lst = malloc(sizeof(t_list));
	if (lst == NULL)
		return (NULL);
	lst->content = content;
	lst->next = NULL;
	return (lst);
}

// This function has to be redefined here cause it normally calls ft_malloc
// and that could prevent tests from being run.
t_list	*test_lst_new_front(t_list **lst, void *content)
{
	t_list	*new_lst;

	new_lst = test_lstnew(content);
	if (new_lst == NULL)
		return (NULL);
	ft_lstadd_front(lst, new_lst);
	return (new_lst);
}

////////////////////////////////////////////////////////////////////////////////

static void	run_tests(void)
{
	t_list	*lst = g_tests_lst;
	while (lst != NULL)
	{
		t_fn_info *fn = lst->content;
		printf("Testing function '%s'\n", fn->fn_name);
		fflush(stdout);
		fn->fn_ptr();

		vector_clean_up();

		was_malloc_unstable = false;
		was_write_unstable = false;

		ft_set_error(FT_OK);

		lst = lst->next;
	}
}

////////////////////////////////////////////////////////////////////////////////

AfterMain(check_leaks)
{
	system("leaks -q tester");
}

////////////////////////////////////////////////////////////////////////////////

int	main(void)
{
	printf("\nRunning tests...\n");

	malloc_call_count = 0;
	write_call_count = 0;
	malloc_call_count_to_fail = 0;
	write_call_count_to_fail = 0;

	run_tests();

	int max_i = ft_max(malloc_call_count, write_call_count);
	int write_fail_offset = max_i / 2;
	int iteration = 1;
	while (iteration <= max_i)
	{
		printf("\nIteration %i / %i:\n", iteration, max_i);

		malloc_call_count = 0;
		write_call_count = 0;
		malloc_call_count_to_fail = iteration;
		write_call_count_to_fail = ((iteration + write_fail_offset) % max_i) + 1;

		run_tests();

		iteration++;
	}

	printf("\nTests ran successfully!\n");

	ft_free_mallocs();

	return (EXIT_SUCCESS);
}

////////////////////////////////////////////////////////////////////////////////
