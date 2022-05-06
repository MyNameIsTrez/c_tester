/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   ctester.c                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: sbos <sbos@student.codam.nl>                 +#+                     */
/*                                                   +#+                      */
/*   Created: 2022/02/05 17:07:20 by sbos          #+#    #+#                 */
/*   Updated: 2022/05/04 16:27:33 by sbos          ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

////////////////////////////////////////////////////////////////////////////////

#include "ctester.h"

////////////////////////////////////////////////////////////////////////////////

t_list *g_tests_lst = NULL;

////////////////////////////////////////////////////////////////////////////////

// This function has to be redefined here cause it normally calls ft_unstable_malloc
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

// This function has to be redefined here cause it normally calls ft_unstable_malloc
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
		fn->fn_ptr();
		lst = lst->next;
	}
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
	int i = 1;
	while (i <= max_i)
	{
		printf("\nIteration %i:\n", i);

		malloc_call_count = 0;
		write_call_count = 0;
		malloc_call_count_to_fail = i;
		write_call_count_to_fail = ((i + write_fail_offset) % max_i) + 1;

		run_tests();

		i++;
	}

	printf("\nTests ran successfully!\n");

	system("leaks tester");

	return (EXIT_SUCCESS);
}

////////////////////////////////////////////////////////////////////////////////
