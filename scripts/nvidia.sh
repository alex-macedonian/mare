#!/bin/bash
#
# nvidia.sh - installs the proprietary drivers for video cards from Nvidia
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

check_package()
{
	if [ -x /usr/bin/nvidia-detect ]; then
		install_deb_packages
	else
		/usr/lib/mare/stifaces.sh
		apt-get install nvidia-detect
		install_deb_packages
	fi
}

install_deb_packages()
{
	local PACKAGE=(nvidia-detect 2> /dev/null | grep "nvidia-")

	case "$PACKAGE" in
		nvidia-driver | nvidia-legacy-340xx-driver | nvidia-legacy-390xx-driver | nvidia-legacy-390xx-driver:amd64 )
		apt-get install linux-headers-$(uname -r|sed 's/[^-]*-[^-]*-//') $PACKAGE
		clean_system

		cat /usr/share/mare/advices.list
		read
		;;
		nvidia-driver/buster-backports | nvidia-tesla-418-driver/buster-backports )
		apt-get install
		clean_system

		cat /usr/share/mare/advices.list
		read
		;;
		* )
		echo "mare: no NVIDIA GPU detected"
		;;
	esac
}

clean_system()
{
	if [ -x /usr/bin/nvidia-detect ]; then
		apt-get -y purge nvidia-detect
	fi
	apt-get -y clean
}

main()
{
	local ANSWER	

	while
		echo -n "Install proprietary drivers from Nvidia (y/n)? "
		read ANSWER
		[ "$ANSWER" != "n" ]
		if [ "$ANSWER" = "y" ]; then
			check_package
			break
		else
			echo "mare: you entered an invalid character"
		fi
	done
}

main
