#!/usr/bin/env bash
#
# optimization.sh - configures the dumping of pages of RAM into the
# swap partition and the amount of RAM allocated for the cache
# (default values: vm.swappiness = 60, vm.vfs_cache_pressure = 100)
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

# Variables for checking the contents of the /etc/sysctl.conf file
SWAPPINESS=$(sysctl -a | grep "vm.swappiness")
VFS_CACHE_PRESSURE=$(sysctl -a | grep "vm.vfs_cache_pressure")

# Edit the /etc/sysctl.conf file
edit_sysctl_conf() 
{
	
	# The variable shows the size of RAM in the operating system
	local MEM_TOTAL=$(free --mega | awk 'FNR == 2 {print $2}')

	if [ "$MEM_TOTAL" -le 1200 ]; then
		sed -i '67a\ ' /etc/sysctl.conf
		sed -i '68a\vm.swappiness=30' /etc/sysctl.conf
		sed -i '69a\vm.vfs_cache_pressure=500' /etc/sysctl.conf
		sysctl -p > /dev/null
	elif [ "$MEM_TOTAL" -le 2200 ]; then
		sed -i '67a\ ' /etc/sysctl.conf
		sed -i '68a\vm.swappiness=5' /etc/sysctl.conf
		sed -i '69a\vm.vfs_cache_pressure=1000' /etc/sysctl.conf
		sysctl -p > /dev/null
	else
		sed -i '67a\ ' /etc/sysctl.conf
		sed -i '68a\vm.swappiness=3' /etc/sysctl.conf
		sed -i '69a\vm.vfs_cache_pressure=1000' /etc/sysctl.conf
		sysctl -p > /dev/null
	fi

}

if [ "$SWAPPINESS" = "vm.swappiness = 60" ] & [ "$VFS_CACHE_PRESSURE" = "vm.vfs_cache_pressure = 100" ]; then
	edit_sysctl_conf
else
	echo "Resetting RAM pages to the swap section and the amount"
	echo "of RAM allocated for the cache is already configured."
fi
