#!/usr/bin/env bash
#
# sysupdate.sh - configures package sources and update the system,
# install or update packages
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

# Variable for checking the contents of the /etc/apt/sources.list file
STRING=$(awk 'FNR == 5 {print $1, $2}' /etc/apt/sources.list)

#################################
# 			FUNCTIONS			#
#################################

# Check the status of network interfaces
state_ifaces() 
{
	
	local STATE_FIRST_IFACE=$(ip a | awk 'FNR == 7 {print $9}')
	local STATE_SECOND_IFACE=$(ip a | awk 'FNR == 9 {print $9}')

	if [ "$STATE_FIRST_IFACE" = "DOWN" ] | [ "$STATE_SECOND_IFACE" = "DOWN" ]; then
		gettext "mare: network connection not established."; echo
		if [ "$STATE_FIRST_IFACE" = "DOWN" ]; then
			gettext "Perhaps the network cable disconnected."; echo
		fi
		if [ "$STATE_SECOND_IFACE" = "DOWN" ]; then
			gettext "You may have entered the wrong access point name or password."; echo
		fi
		exit 1
	fi

}

# Configure package sources by editing the /etc/apt/sources.list file
edit_sources_list() 
{

	local CDROM=$(sed -n '3p' /etc/apt/sources.list)
	local COUNTRY=0
	local MIRROR_LIST=0
	local MIRROR=0
	local AVG=0
	local WORD_LIGNTH=0
	local PREFIX=0
	local LIST=0
	local SITE=0
	
	# show list of countries in alphabetical order
	cat /usr/share/mare/countries.list
	
	while [ "$#" -eq 0 ]; do
		gettext "Enter your country: "
		read COUNTRY
		echo ""

		# assign a value to a variable
		MIRROR_LIST=$(sed -n '/'${COUNTRY}'/p' /usr/share/mare/mirror.list | awk 'FNR == 1 {print $1}')
		
		# check entered country by user in the /usr/share/mare/mirror.list file
		if [ "$MIRROR_LIST" = "$COUNTRY" ]; then
			
			# assign a value to a variable
			MIRROR=$(sed -n '/'${COUNTRY}'/p' /usr/share/mare/mirror.list | cut -d"/" -f3)
			
			# show the list of mirrors for the specified country
			for MIRROR in $MIRROR; do
				AVG=$(ping -c 5 ${MIRROR} | awk 'FNR == 10' | cut -d"/" -f6 )
				if [ -z "$AVG" ]; then
					AVG=0
				fi

				# align the string in width
				WORD_LIGNTH=$(echo "${MIRROR}" | wc -m)
				PREFIX=$(expr 47 - $WORD_LIGNTH)
				echo "${COUNTRY} ${MIRROR} ${AVG}" | awk '{printf "%-20s %s %'${PREFIX}'s\n", $1, $2, $3}'
			done

			echo ""
			# remove the previous value from the variable
			MIRROR=0
			
			while [ "$#" -eq 0 ]; do
				gettext "Enter the mirror: "
				read MIRROR
				# assign a value to a variable
				LIST=$(sed -n '/'$MIRROR'/p' /usr/share/mare/mirror.list | cut -d"/" -f3)
				
				# verify user input is correct
				if [ "$MIRROR" = "$LIST" ]; then
					# assign a value to a variable
					SITE=$(sed -n '/'${MIRROR}'/p' /usr/share/mare/mirror.list | awk 'FNR == 1 {print $2}')
					# get out of the loop
					break
				else
					gettext "Error! This mirror is not in the list of available mirrors."; echo
				fi
			done
			# get out of the loop
			break
		else
			gettext "Error! There is no mirror for your country."; echo
			gettext "Please indicate the country closest to you."; echo
		fi
	done
	
	# overwrite the contents of the specified file
	# based on the information received
	cat > /etc/apt/sources.list << EOF
# 

# ${CDROM}

# ${CDROM}

deb http://security.debian.org/debian-security buster/updates main contrib non-free
# deb-src http://security.debian.org/debian-security buster/updates main contrib non-free

deb ${SITE} buster-proposed-updates main contrib non-free
# deb-src ${SITE} buster-proposed-updates main contrib non-free

deb ${SITE} buster-updates main contrib non-free
# deb-src ${SITE} buster-updates main contrib non-free

deb ${SITE} buster main contrib non-free
# deb-src ${SITE} buster main contrib non-free
EOF
	
}

###################### BEGIN ######################
	
# if this file exists, then delete it
if [ -f /etc/apt/sources.list.d/base.list ]; then
	rm /etc/apt/sources.list.d/base.list
fi
	
if [ "$STRING" = "deb cdrom:[Debian" ]; then
	# check the status of network interfaces
	state_ifaces

	# configure package sources by editing the /etc/apt/sources.list file
	edit_sources_list
			
	# update the list of available packages
	apt update
			
	# upgrade the system by installing or updating packages
	apt -y upgrade
else
	gettext "Package sources are is already configured."; echo
fi

###################### END ######################
