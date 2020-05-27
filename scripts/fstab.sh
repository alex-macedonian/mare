#!/usr/bin/env bash
#
# fstab.sh - configures filesystems table
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

NUMBER=0
OPTIONS=0
STRING=0

###################### BEGIN ######################

gettext "Here you can specify the parameters for mounting the hard"; echo
gettext "drive to fine-tune them. Parameters: errors=remount-ro"; echo
gettext "is best left unchanged. For example, you can specify them"; echo
gettext "like this: rw,relatime,errors=remount-ro. See mount(8)"; echo
gettext "for more information."; echo
echo
	
# show all lines of the file and number them
sed -n -e '1,$p' -e '/$/=' /etc/fstab
echo	

while
	gettext "Enter string number («Q» - out): "
	read NUMBER
	[ $NUMBER != "q" ]; do
	gettext "Enter mount options: "
	read OPTIONS
	STRING=$(awk 'FNR == '${NUMBER}' {print $4}' /etc/fstab)
	sed -i 's/'${STRING}'/'${OPTIONS}'/g' /etc/fstab
done

###################### END ######################
