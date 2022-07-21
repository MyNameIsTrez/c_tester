/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   ctester_globals.h                                  :+:    :+:            */
/*                                                     +:+                    */
/*   By: sbos <sbos@student.codam.nl>                 +#+                     */
/*                                                   +#+                      */
/*   Created: 2022/04/05 15:33:56 by sbos          #+#    #+#                 */
/*   Updated: 2022/07/21 11:29:58 by sbos          ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

////////////////////////////////////////////////////////////////////////////////

#ifndef CTESTER_GLOBALS_H
# define CTESTER_GLOBALS_H

////////////////////////////////////////////////////////////////////////////////

extern int malloc_call_count;
extern int malloc_call_count_to_fail;
extern bool was_malloc_unstable;

extern int write_call_count;
extern int write_call_count_to_fail;
extern bool was_write_unstable;

////////////////////////////////////////////////////////////////////////////////

#endif

////////////////////////////////////////////////////////////////////////////////
