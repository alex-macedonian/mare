#!/bin/bash
#
# codecs.sh - sets up additional codecs in of the operating system 
# Debian GNU/Linux
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

edit_sources_list()
{
	local STRING_MMEDIA=$(sed -n '19,20p' /etc/apt/sources.list)
	
	# check contents of sources.list file
	# if the necessary lines exist in it, then inform the user about it
	if [ -n "$STRING_MMEDIA" ]; then
		echo "The www.deb-multimedia.org website has already"
		echo "been added to the /etc/apt/sources.list file."
	# otherwise edit the sources.list file
	else
		sed -i '14a\ ' /etc/apt/sources.list
		sed -i '15a\deb '${SITE_MMEDIA}' buster main non-free' /etc/apt/sources.list
		sed -i '16a\# deb-src '${SITE_MMEDIA}' buster main non-free' /etc/apt/sources.list
	fi
}

check_package()
{
	local SITE_MMEDIA="http://www.deb-multimedia.org"

	# check if the package is installed
	# if the package is installed, then inform the user about it
	if [ -f /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg ]; then
		echo "The deb-multimedia-keyring package is already installed on your system."
	else
		# create a directory to store temporary files
		mkdir -p /tmp/mare
		# change current working directory to /tmp/dpkg
		cd /tmp/mare
		# download the deb-multimedia-keyring package to the current working directory
		wget $SITE_MMEDIA/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb
		
		# return to user home directory
		cd
		# install the deb-multimedia-keyring package
		dpkg --install /tmp/mare/deb-multimedia-keyring_2016.8.1_all.deb

		apt update
		apt -y upgrade
		install_additional_codecs
		clean_system
	fi
}

install_additional_codecs() 
{
	local SYS_ARCH=$(arch)
	local PACKAGE_LIST=0

	# create a list of packages to install
	case "$SYS_ARCH" in
		x86 )
		echo " w32codecs" > /tmp/mare/package.list
		;;
		x86-64 )
		echo " w64codecs" > /tmp/mare/package.list
		;;
	esac
	
	if [ -x /lib/firefox-esr/firefox-esr ]; then
		sed -i 's/ */flashplayer-mozilla /' /tmp/mare/package.list
	fi

	if [ -x /usr/bin/chromium ]; then
		 sed -i 's/ */flashplayer-chromium /' /tmp/mare/package.list
	fi

	PACKAGE_LIST=$(cat /tmp/mare/package.list)
	# install packages from the list
	apt-get -y install $PACKAGE_LIST
}

clean_system()
{
	# clean up garbage after installing packages
	echo "Cleaning the system from unnecessary files and directories."
	rm -R /tmp/mare
	apt-get -y clean > /dev/null
	apt-get -y autoremove > /dev/null
}

check_distribution()
{
	local DEBIAN=$(awk '$1 ~ /Debian/ {print $1}' /usr/share/mare/version.list)	
	
	if [ -n "$DEBIAN" ]; then
		edit_sources_list
		check_package
	else
		echo "mare: this script only works with Debian GNU/Linux"
	fi
}

main()
{
	check_distribution
}

main
