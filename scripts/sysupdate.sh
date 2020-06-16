#!/usr/bin/env bash
#
# sysupdate.sh - configures package sources and update the operating system
# Debian GNU/Linux or LMDE
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

MESAGE="\
Choosing a Debian repository mirror.
When choosing it, be guided by the delay
time located behind the mirror."

# Variable for checking the contents of the /etc/apt/sources.list file
WORDS=$(awk '$5 ~ /non-free/ {print $5} ' /etc/apt/sources.list)

#################################
# 			FUNCTION			#
#################################

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
		echo -n "Enter your country: "
		read COUNTRY
		echo ""

		# assign a value to a variable
		MIRROR_LIST=$(sed -n '/'${COUNTRY}'/p' /usr/share/mare/mirror.list | awk 'FNR == 1 {print $1}')
		
		# check entered country by user in the /usr/share/mare/mirror.list file
		if [ "$MIRROR_LIST" = "$COUNTRY" ]; then
			echo -e "${MESAGE}\n"
			
			# assign a value to a variable
			MIRROR=$(sed -n '/'${COUNTRY}'/p' /usr/share/mare/mirror.list | cut -d"/" -f3)
			
			# show the list of mirrors for the specified country
			for MIRROR in $MIRROR; do
				AVG=$(ping -c 5 -i 0.2 -q ${MIRROR} | awk 'FNR == 5' | cut -d"/" -f6)
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
				echo -n "Enter a low latency mirror: "
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
					echo "`basename $0:` this mirror is not in the list of available mirrors."
				fi
			done
			# get out of the loop
			break
		else
			echo "`basename $0:` there is no mirror for your country."
			echo "Please indicate the country closest to you."
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
	
if [ "$WORDS" = "non-free" ]; then
	# check the status of network interfaces
	/usr/share/mare/stifaces.sh

	# configure package sources by editing the /etc/apt/sources.list file
	edit_sources_list
			
	# update the list of available packages
	apt update
			
	# upgrade the system by installing or updating packages
	apt -y upgrade
else
	echo "Package sources are is already configured."
fi

###################### END ######################
