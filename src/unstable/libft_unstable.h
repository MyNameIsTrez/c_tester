/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   libft_unstable.h                                   :+:    :+:            */
/*                                                     +:+                    */
/*   By: sbos <sbos@student.codam.nl>                 +#+                     */
/*                                                   +#+                      */
/*   Created: 2022/03/25 16:17:18 by sbos          #+#    #+#                 */
/*   Updated: 2022/04/07 17:51:02 by sbos          ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

////////////////////////////////////////////////////////////////////////////////

#ifndef LIBFT_UNSTABLE_H
# define LIBFT_UNSTABLE_H

////////////////////////////////////////////////////////////////////////////////

// TODO: These headers are also being included in libft, can this be helped?
# include <stdlib.h>	// size_t, ssize_t?, intmax_t, NULL, malloc, free
# include <sys/types.h> // ssize_t
# include <unistd.h>	// write

////////////////////////////////////////////////////////////////////////////////

# include "libft_unstable_malloc.h"
# include "libft_unstable_write.h"

////////////////////////////////////////////////////////////////////////////////

void	*ft_unstable_malloc(size_t size);
ssize_t	ft_unstable_write(int fildes, const void *buf, size_t nbyte);

////////////////////////////////////////////////////////////////////////////////

#endif

////////////////////////////////////////////////////////////////////////////////
