#!/usr/bin/env bash
#
# dm.sh - configures the LightDM display manager in of the operating system 
# Debian GNU/Linux or LMDE
# Copyright (C) 2020 Alexandre Popov <amocedonian@gmail.com>.
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

LIGHTDM=$(dpkg -l 2> /dev/null | grep lightdm | awk 'FNR == 2 {print $2}')

# enable numlock by default for LightDM
if [ -n "$LIGHTDM" ]; then
	if [ -f /usr/bin/numlockx ]; then
		echo "The numlockx package is already installed on your system."
	else
		# check the status of network interfaces
		/usr/share/mare/stifaces.sh
		apt-get -y install numlockx
	fi
	
	if [ -f /usr/share/lightdm/lightdm.conf.d/01_user.conf ]; then
		echo "The configuration file for LightDM already exists."
	else
		echo " " > /usr/share/lightdm/lightdm.conf.d/01_user.conf
		sed -i '1c\[Seat:*]' /usr/share/lightdm/lightdm.conf.d/01_user.conf
		sed -i '1a\greeter-setup-script=/usr/bin/numlockx on' /usr/share/lightdm/lightdm.conf.d/01_user.conf
	fi
fi
