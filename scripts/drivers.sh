#!/usr/bin/env bash
#
# drivers.sh - installs micro programs for your operating system
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

AMD=$(lspci | grep VGA | awk '{print $9}')
CHECK_PACK=$(dpkg -l xserver-xorg-video-ati 2> /dev/null | awk 'FNR == 8 {print $2}')
NONFREE_PACK=$(dpkg -l firmware-linux-nonfree 2> /dev/null | awk 'FNR == 8 {print $2}')
LIBGLX_MESA=$(dpkg -l libglx-mesa0 2> /dev/null | awk 'FNR == 8 {print $2}')
CPU=$(lspci | grep Host | awk 'FNR == 2 {print $8}')

###################### BEGIN ######################

# Install free drivers for video cards AMD/ATI.
# Installing free drivers for AMD/ATI video cards
# is preferable, as they better support hardware  
# acceleration in 3-D applications, which include
# modern games.
# Check if the xserver-xorg-video-ati package is
# installed. This package depends on three
# hardware-dependent driver packages:
# xserver-xorg-video-mach64, xserver-xorg-video-r128
# and xserver-xorg-video-radeon. The 
# xserver-xorg-video-ati package automatically detects
# whether your hardware has Radeon, Rage 128, or Mach64
# and loads the appropriate driver.
if [ "$AMD" = "[AMD/ATI]" ]; then
	if [ -n "$CHECK_PACK" ]; then
		gettext "The xserver-xorg-video-ati package is already installed."; echo
	else
		apt-get -y install xserver-xorg-video-ati
	fi

	# Check whether the package libglx-mesa0 is installed,
	# which in turn installs other packages related to it.
	if [ -n "$LIBGLX_MESA" ]; then
		gettext "The libglx-mesa0 package is already installed."; echo
	else
		apt-get -y install libglx-mesa0
	fi

	# Installing the binary package firmware-linux-nonfree.
	# Without this package, radeon driver users typically
	# experience poor 2D/3D performance. Some video cards
	# need this firmware to run the X Window System. 
	if [ -n "$NONFREE_PACK" ]; then
		gettext "The firmware-linux-nonfree package is already installed."; echo
	else
		apt-get -y install firmware-linux-nonfree
	fi
fi

# Install microcode patches for all AMD AMD64 processors.
# AMD releases microcode patches to correct processor 
# behavior as documented in. 
if [ "$CPU" = "[AMD]" ]; then
	apt-get -y install amd64-microcode
	echo
	gettext "IT IS VERY IMPORTANT! If you are not running the"; echo
	gettext "X Window System, then restart the computer now."; echo
	gettext "Press enter ..."; read
fi

# Install updated system processor microcode for Intel
# i686 and Intel X86-64 processors. Intel releases
# microcode updates to correct processor behavior as
# documented in the respective processor specification
# updates. 
if [ "$CPU" = "[Intel]" ]; then
	apt-get -y install intel-microcode
fi

###################### END ######################
