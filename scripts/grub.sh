#!/bin/bash
#
# grub.sh - configures bootloader operating system Debian GNU/Linux
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

check_distribution()
{
	local DISTRO=$(awk '$1 ~ /Debian/ {print $1}' /usr/share/mare/version.list)

	if [ -n "$DISTRO" ]; then
		check_string
	else
		echo "mare: you are using a different distribution GNU/Linux"
	fi
}

check_string()
{
	# Variable for checking the contents of the  /etc/default/grub file
	local CMDLINE_LINUX_DEFAULT=$(grep -o "quiet splash" /etc/default/grub)
	
	if [ -z "$CMDLINE_LINUX_DEFAULT" ]; then
		check_other_os
	else
		echo "The operating system bootloader is already configured."
	fi
}

check_other_os()
{
	local CHECK_OTHER_OS=$(os-prober | cut -d":" -f2)
	# Variable for checking the contents of the  /etc/default/grub file
	local TIMEOUT_STYLE=$(grep -o "hidden" /etc/default/grub)
	
	if [ -n "$CHECK_OTHER_OS" ]; then
		check_plymouth
	else
		if [ -z "$TIMEOUT_STYLE" ]; then
			sed -i '7i\GRUB_TIMEOUT_STYLE=hidden' /etc/default/grub
			sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
		fi
		check_plymouth
	fi
}

check_plymouth()
{
	if [ -x /bin/plymouth ]; then
		configure_grub
	else
		/usr/lib/mare/stifaces.sh
		apt-get install plymouth plymouth-label
		configure_grub
	fi
}

configure_grub()
{
	local ANSWER=0	

	while
		echo -n "Install the mare theme for Grub (y/n)? "
		read ANSWER
		[ "$ANSWER" != "n" ]; do
		if [ "$ANSWER" = "y" ]; then
			# install the Mare theme for the operating system bootloader
			chmod +x /etc/grub.d/06_mare_theme
			sed -i 's/quiet/quiet splash/g' /etc/default/grub
			update-grub
			# install default theme for plymouth
			plymouth-set-default-theme -R futureprototype
			break
		fi
	done

	sed -i 's/quiet/quiet splash/g' /etc/default/grub
	update-grub
	# install default theme for plymouth
	plymouth-set-default-theme -R futureprototype
}

main()
{
	check_distribution
}

main
