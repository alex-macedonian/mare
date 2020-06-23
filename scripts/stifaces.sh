#!/usr/bin/env bash
#
# stifaces.sh - checks the status of network interfaces
#
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

STATE_FIRST_IFACE=$(ip a | awk 'FNR == 7 {print $9}')
STATE_SECOND_IFACE=$(ip a | awk 'FNR == 9 {print $9}')

if [ "$STATE_FIRST_IFACE" = "DOWN" ] | [ "$STATE_SECOND_IFACE" = "DOWN" ]; then
	echo "`basename $0:` network connection not established."
	if [ "$STATE_FIRST_IFACE" = "DOWN" ]; then
		echo "Perhaps the network cable disconnected."
	fi
	if [ "$STATE_SECOND_IFACE" = "DOWN" ]; then
		echo "You may have entered the wrong access point name or password."
	fi
	exit 1
fi
