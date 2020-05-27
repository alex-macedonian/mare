#!/usr/bin/env bash
#
# codecs.sh - sets up additional codecs for your system
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

MMEDIA_KEYRING_PACKAGE=$(dpkg -l 2> /dev/null | grep deb-multimedia-keyring | awk '{print $2}')
STRING_MMEDIA=$(sed -n '19,20p' /etc/apt/sources.list)
SITE_MMEDIA="http://www.deb-multimedia.org"

# Array for a function that installs additional codecs in the system
declare -a possible_codecs
possible_codecs[0]="libdvdcss2"
possible_codecs[1]="libavcodec58"
possible_codecs[2]="libcodec2-0.8.1"
possible_codecs[3]="libcommons-codec-java"
possible_codecs[4]="libde265-0"
possible_codecs[5]="libopencore-amrnb0"
possible_codecs[6]="libopencore-amrwb0"
possible_codecs[7]="libopus0"
possible_codecs[8]="libspeex1"
possible_codecs[9]="libvpx5"
possible_codecs[10]="libwavpack1"
possible_codecs[11]="libxvidcore4"
possible_codecs[12]="libass9"
possible_codecs[13]="libcrystalhd3"
possible_codecs[14]="libdca0"
possible_codecs[15]="libdv4"
possible_codecs[16]="libdvdnav4"
possible_codecs[17]="libdvdread4"
possible_codecs[18]="libfaad2"
possible_codecs[20]="libflac8"
possible_codecs[21]="libkate1"
possible_codecs[22]="libmjpegutils-2.1-0"
possible_codecs[23]="libmp3lame0"
possible_codecs[24]="libmpcdec6"
possible_codecs[25]="libmpeg2-4"
possible_codecs[26]="libmpg123-0"
possible_codecs[27]="libpostproc55"
possible_codecs[28]="libshine3"
possible_codecs[29]="libshout3"
possible_codecs[30]="libswresample3"
possible_codecs[31]="libswscale5"
possible_codecs[32]="libtag1v5"
possible_codecs[33]="libtagc0"
possible_codecs[34]="libtheora0"
possible_codecs[35]="libtwolame0"
possible_codecs[36]="libvo-aacenc0"
possible_codecs[37]="libvo-amrwbenc0"
possible_codecs[38]="libvorbis0a"
possible_codecs[39]="libx264-155"
possible_codecs[40]="libx265-165"

#################################
# 			FUNCTION			#
#################################

# Install additional codecs
install_additional_codecs() 
{
	
	local SYS_ARCH=$(dmesg 2> /dev/null | grep architecture | awk '{print $6}')
	local FIREFOX_PACKAGE=$(dpkg -l 2> /dev/null | grep firefox-esr | awk 'FNR == 1 {print $2}')
	local CHROMIUM_PACKAGE=$(dpkg -l 2> /dev/null | grep chromium | awk 'FNR == 1 {print $2}')
	
	apt-get update
	apt-get -y upgrade

	case "$SYS_ARCH" in
		x86. )
		apt-get -y install w32codecs
		;;
		x86-64. )
		apt-get -y install w64codecs
		;;
	esac
	
	if [ -n "$FIREFOX_PACKAGE" ]; then
		apt-get -y install flashplayer-mozilla
	fi

	if [ -n "$CHROMIUM_PACKAGE" ]; then
		apt-get -y install flashplayer-chromium
	fi
	
	for possible_codecs in ${possible_codecs[*]}; do
		apt-get -y install $possible_codecs
	done

}

###################### BEGIN ######################

gettext "Preparing to install additional codecs that are not"; echo
gettext "shipped with the Debian GNU/Linux 10 operating system"; echo
gettext "distribution."; echo; echo

# check contents of sources.list file
# if the necessary lines exist in it, then inform the user about it
if [ -n "$STRING_MMEDIA" ]; then
	gettext "The www.deb-multimedia.org website has already"; echo
	gettext "been added to the /etc/apt/sources.list file."; echo
# otherwise edit the sources.list file
else
	sed -i '17a\ ' /etc/apt/sources.list
	sed -i '18a\deb '${SITE_MMEDIA}' buster main non-free' /etc/apt/sources.list
	sed -i '19a\# deb-src '${SITE_MMEDIA}' buster main non-free' /etc/apt/sources.list
fi

# check if the package is installed
# if the package is installed, then inform the user about it
if [ -n "$MMEDIA_KEYRING_PACKAGE" ]; then
	gettext "The deb-multimedia-keyring package is already installed on your system."; echo
else
		
	# create a directory to store temporary files
	mkdir -p /tmp/dpkg 
	# change current working directory to /tmp/dpkg
	cd /tmp/dpkg
	# download the deb-multimedia-keyring package to the current working directory
	wget $SITE_MMEDIA/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb
		
	# return to user home directory
	cd
	# install the deb-multimedia-keyring package
	dpkg -i /tmp/dpkg/deb-multimedia-keyring_2016.8.1_all.deb
		
	# update the list of available packages
	apt update > /dev/null
	# install additional codecs
	install_additional_codecs
		
	# clean up garbage after installing packages
	gettext "Cleaning the system from unnecessary files and directories."; echo
	rm -R /tmp/dpkg
	apt-get -y clean > /dev/null
fi

###################### END ######################
