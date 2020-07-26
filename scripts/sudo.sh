#!/bin/bash
#
# sudo.sh - configures elevated user privileges
#
# Copyright (C) 2019 - 2020 Alexandre Popov <consiorp@gmail.com>.
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

LC_ALL=C
export LC_ALL

edit_sudoers()
{
	local ROOT_USER=$(grep "root" /etc/passwd | cut -d":" -f1)
	local SUDO_GROUP=$(grep "sudo" /etc/group | cut -d":" -f4)
	local HOST_NAME=$(uname --nodename)
	local USER_NAME=$(grep "video" /etc/group | cut -d":" -f4)

	# check if root user exists
	if [ -n "$ROOT_USER" ]; then
		# check if regular user is added to sudo group
		if [ -z "$SUDO_GROUP" ]; then
			# define an alias for the host name
			sed -i '13a\Host_Alias HOST = '${HOST_NAME}'' /etc/sudoers
			# define an alias for the username
			sed -i '15a\User_Alias ADMIN = '${USER_NAME}'' /etc/sudoers
			# Grant access rights for a user with the alias ADMIN.
			# The HOST=(ALL: ALL) ALL snippet means that a user with the alias
			# ADMIN can use the sudo package to execute commands in root mode.
			# The word HOST means the assigned hostname alias. The word ALL
			# means "any command." Additional parameters (ALL: ALL) mean that
			# a user with the alias ADMIN can run commands, like any other user
			# any group.
			sed -i '20a\ADMIN	HOST=(ALL:ALL) ALL' /etc/sudoers
		fi
	fi
}

main()
{
	edit_sudoers
}

main
