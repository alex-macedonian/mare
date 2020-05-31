#!/usr/bin/env bash
#
# wifi.sh - creates a new Wi-Fi connection in NetworkManager using
# the nmcli command
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

#################################
#           VARIABLES           #
#################################

SSID=0
PASWD=0
CHECK_IFACE=$(ip a | awk 'FNR == 9 {print $2}' | cut -d":" -f1)

###################### BEGIN ######################

if [ -n $CHECK_IFACE ]; then
	echo -n "Enter the name of the wireless access point: "
	read SSID
	if [ -f /etc/NetworkManager/system-connections/$SSID.* ]; then
		echo "A new network connection has already been created."
	else
		echo -n "Enter the password: "
		read PASWD
		nmcli device wifi connect $SSID password $PASWD
	fi
else
	echo "`basename $0:` wireless, network interface not found."
fi

###################### END ######################
