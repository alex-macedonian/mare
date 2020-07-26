#!/bin/bash
#
# netman.sh - configures Network Manager
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

LC_ALL=C
export LC_ALL

configure_network_manager() 
{
	
	# Variable for checking the contents of the /etc/NetworkManager/NetworkManager.conf file
	local NET_MANAGER=$(awk '$1 ~ /^w/' /etc/NetworkManager/NetworkManager.conf 2> /dev/null )

	if [ -f /etc/NetworkManager/NetworkManager.conf ]; then
		if [ -n "$NET_MANAGER" ]; then
			echo "Random MAC address is already disabled in the NetworkManager."
		else
			sed -i '5a\ ' /etc/NetworkManager/NetworkManager.conf
			sed -i '6a\[device]' /etc/NetworkManager/NetworkManager.conf
			sed -i '7a\wifi.scan-rand-mac-address=no' /etc/NetworkManager/NetworkManager.conf
		fi
	else
		echo "mare: the NetworkManager.conf file does not exist"
	fi
	
}

main()
{
	configure_network_manager
}

main
