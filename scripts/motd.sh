#!/usr/bin/env bash
#
# motd.sh - configures the Message of the Day in Debian GNU/Linux
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

#################################
# 			FUNCTIONS			#
#################################

# Preparing to customize the message of the day in Debian GNU/Linux
preparation_for_set_motd() 
{

	local LOGIN=$(awk 'FNR == 91 {print}' /etc/pam.d/login)

	echo
	gettext "Setting up a dynamic message of the day. This is necessary"; echo
	gettext "so that your console, after authentication, displays a"; echo
	gettext "greeting and useful information about your operating system."; echo
	echo

	# check file contents
	# if the file is not empty, clear it
	if [ -s /etc/motd ]; then
		cat /dev/null > /etc/motd
	fi

	if [ -x /etc/update-motd.d/10-uname ]; then
		chmod -x /etc/update-motd.d/10-uname
	fi

	# check priority of message output of the day
	# if the message about the last user authentication is displayed before the message  
	# of the day, prompt the user to fix this by editing the /etc/pam.d/login file
	if [ "$LOGIN" = "session    optional   pam_lastlog.so" ]; then
		gettext "Now in the console, the message about the last user"; echo
		gettext "authentication is displayed before the message of the day."; echo; echo
		edit_login
	# otherwise display a message that the message of the day is displayed 
	# before the message about the last user authentication
	else
		gettext "Now in the console, the message of the day is displayed"; echo
		gettext "before the message about the last user authentication."; echo; echo
	fi
	
}

# Edit the /etc/pam.d/login file
edit_login() 
{
	
	local CHAR=0

	while
		gettext "Display message of the day first? (y or n): "
		read CHAR
		[ "$CHAR" != "n" ]; do
		if [ "$CHAR" = "y" ]; then 
			sed -i '100i\# Prints the last login info upon successful login' /etc/pam.d/login
			sed -i '101i\# (Replaces the "LASTLOG_ENAB" option from login.defs)' /etc/pam.d/login
			sed -i '102i\session    optional   pam_lastlog.so' /etc/pam.d/login
			sed -i '103i\ ' /etc/pam.d/login
			sed -i '89,92d' /etc/pam.d/login
			break
		else
			gettext "Error! You have entered an invalid character."; echo
		fi
	done
	
}

###################### BEGIN ######################

# preparing to customize the message of the day in Debian GNU/Linux
preparation_for_set_motd

if [ -f /etc/update-motd.d/00-welcome-header ]; then
	chmod +x /etc/update-motd.d/00-welcome-header
fi

if [ -f /etc/update-motd.d/10-system-info ]; then
	chmod +x /etc/update-motd.d/10-system-info
fi

if [ -f /etc/update-motd.d/20-connect-info ]; then
	chmod +x /etc/update-motd.d/20-connect-info
fi

###################### END ######################
