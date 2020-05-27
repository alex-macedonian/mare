#!/usr/bin/env bash
#
# dm.sh - configures the LightDM display manager
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

LIGHTDM=$(dpkg -l 2> /dev/null | grep lightdm | awk 'FNR == 2 {print $2}')

###################### BEGIN ######################

# enable numlock by default for LightDM
if [ -n "$LIGHTDM" ]; then
	if [ -f /usr/bin/numlockx ]; then
		gettext "The numlockx package is already installed on your system."; echo
	else
		apt-get -y install numlockx
	fi
	
	if [ -f /usr/share/lightdm/lightdm.conf.d/01_user.conf ]; then
		gettext "The configuration file for LightDM already exists."; echo
	else
		echo " " > /usr/share/lightdm/lightdm.conf.d/01_user.conf
		sed -i '1c\[Seat:*]' /usr/share/lightdm/lightdm.conf.d/01_user.conf
		sed -i '1a\greeter-setup-script=/usr/bin/numlockx on' /usr/share/lightdm/lightdm.conf.d/01_user.conf
	fi
fi

###################### END ######################
