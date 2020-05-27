#!/usr/bin/env bash
#
# wifi.sh - installs micro programs for USB wireless network and
# Bluetooth cards supported by the ar5523, ath3k, ath6kl_sdio,
# ath6kl_usb, ath9k_htc, ath10k, or wilc6210 drivers.
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

CDROM=$(awk 'FNR == 3 {print $9}' /etc/apt/sources.list) 
FIRMWARE_ATHEROS_PACKAGE=$(dpkg -l 2> /dev/null | grep firmware-atheros | awk '{print $2}')
FIND_FILE=$(find /home -name firmware-atheros*)

#################################
# 			FUNCTION			#
#################################

# Edit the /etc/NetworkManager/NetworkManager.conf file
edit_network_manager_conf() 
{
	
	# Variable for checking the contents of the /etc/NetworkManager/NetworkManager.conf file
	local NET_MANAGER=$(awk 'FNR == 8 {print}' /etc/NetworkManager/NetworkManager.conf)

	if [ -n "$NET_MANAGER" ]; then
		gettext "Random MAC address is already disabled in the NetworkManager."; echo
	else
		sed -i '5a\ ' /etc/NetworkManager/NetworkManager.conf
		sed -i '6a\[device]' /etc/NetworkManager/NetworkManager.conf
		sed -i '7a\wifi.scan-rand-mac-address=no' /etc/NetworkManager/NetworkManager.conf
	fi
	
}

###################### BEGIN ######################

if [ "$CDROM" = "DVD" ]; then
	# check, if the package is installed
	# if the package is installed, then
	# inform the user about it
	if [ -n "$FIRMWARE_ATHEROS_PACKAGE" ]; then
		gettext "The firmware-atheros package is already installed on your system."; echo
	# otherwise install the package
	else
		if [ -f $FIND_FILE ]; then
			dpkg --install $FIND_FILE
		else
			gettext "mare: the firmware-atheros package is not found."; echo
			exit 1
		fi

		if [ -f /etc/NetworkManager/NetworkManager.conf ]; then
			# edit the /etc/NetworkManager/NetworkManager.conf file
			edit_network_manager_conf
		else
			gettext "mare: the NetworkManager.conf file does not exist."; echo
			exit 1
		fi
	fi

	gettext "IT IS VERY IMPORTANT! Restart the computer NOW to apply the changes."; echo
	gettext "Press enter ..."; read	

else
	gettext "mare: you are using a different storage medium information."; echo
	exit 1
fi

###################### END ######################
