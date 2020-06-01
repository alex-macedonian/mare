#!/usr/bin/env bash
#
# menu.sh - script menu
# Copyright (C) 2020 Alexandre Popov <amocedonian@gmail.com>.
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

# Variable for selecting an operation in a script
CHOICE=0
# Variable to enter the return symbol
DUMMY=0

###################### BEGIN ######################

# endless loop creates a script menu
while :
do
	cat /usr/share/mare/data/menu.list
	echo -n "Your Choice [1,2,3,4,5,6,7,8,9,10,11,12,H,Q] > "
	read CHOICE
	
	case "$CHOICE" in
		1 )
		/usr/share/mare/network.sh
		;;
		2 )
		/usr/share/mare/wificon.sh
		;;
		3 )
		/usr/share/mare/sudo.sh
		;;
		4 )
		/usr/share/mare/sysupdate.sh
		;;
		5 )
		/usr/share/mare/drivers.sh
		;;
		6 )
		/usr/share/mare/grub.sh
		;;
		7 )
		/usr/share/mare/fstab.sh
		;;
		8 )
		/usr/share/mare/optimization.sh
		;;
		9 )
		/usr/share/mare/packages.sh
		;;
		10 )
		/usr/share/mare/codecs.sh
		;;
		11 )
		/usr/share/mare/motd.sh
		;;
		12 )
		/usr/share/mare/dm.sh
		;;
		H | h )
		man mare
		;;
		Q | q )
		exit 0
		;;
		* )
		echo "`basename $0:` unknown user response."
		exit 1
		;;
	esac
	echo "Hit the return key to continue "
	read DUMMY
	# clear screen
	clear
done
	
###################### END ######################
