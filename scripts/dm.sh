#!/bin/bash
#
# dm.sh - configures the LightDM display manager
#
# Copyright (C) 2020 Alexandre Popov <consiorp@gmail.com>.
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

check_distribution()
{
	local DISTRO=$(awk '{if (($1 ~ "Debian") || ($1 ~ "LMDE")) {print $3}}' /usr/share/mare/version.list)
	
	if [ -n "$DISTRO" ]; then
		if [ -x /usr/sbin/lightdm ]; then
			configure_lightdm
		fi
	else
		echo "mare: you are using a different distribution GNU/Linux"
		exit 1
	fi
}

configure_lightdm()
{
	# enable numlock by default for LightDM
	if [ -x /usr/bin/numlockx ]; then
		echo "The numlockx package is already installed on your system."
	else
		# check the status of network interfaces
		/usr/lib/mare/stifaces.sh
		apt-get -y install numlockx
	fi
	
	if [ -f /usr/share/lightdm/lightdm.conf.d/01_user.conf ]; then
		echo "The configuration file for LightDM already exists."
	else
		echo " " > /usr/share/lightdm/lightdm.conf.d/01_user.conf
		sed -i '1c\[Seat:*]' /usr/share/lightdm/lightdm.conf.d/01_user.conf
		sed -i '1a\greeter-setup-script=/usr/bin/numlockx on' /usr/share/lightdm/lightdm.conf.d/01_user.conf
	fi
}

main()
{
	check_distribution
}

main
