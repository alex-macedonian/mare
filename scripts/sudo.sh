#!/usr/bin/env bash
#
# sudo.sh - configures elevated user privileges
# Copyright (C) 2019 - 2020 Alexandre Popov <amocedonian@gmail.com>.
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

#################################
#           VARIABLES           #
#################################

# Variables to support script internationalization
#TEXTDOMAINDIR=/usr/share/locale
#export TEXTDOMAINDIR
#TEXTDOMAIN=mare
#export TEXTDOMAIN

# Variable for checking the contents of the /etc/sudoers file
SUDOERS=$(awk 'FNR == 21 {print}' /etc/sudoers 2> /dev/null)
NAME=0

###################### BEGIN ######################

gettext "Enter your username: "
read NAME
# check  for the presence of the string username	ALL=(ALL: ALL) ALL
# if such a line exists, then inform the user about it
if [ -n "$SUDOERS" ]; then
	gettext "Elevated user privileges are already configured."; echo
else
	sed -i '20a\'${NAME}'	ALL=(ALL:ALL) ALL' /etc/sudoers
fi

###################### END ######################
