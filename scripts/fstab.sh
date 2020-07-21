#!/bin/bash
#
# fstab.sh - configures filesystems table
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
	local DISTRO=$(awk '{if (($1 ~ "Debian") || ($1 ~ "LMDE")) {print $1}}' /usr/share/mare/version.list)

	if [ -n "$DISTRO" ]; then
		edit_fstab
	else
		echo "mare: you are using a different distribution GNU/Linux"
		exit 1
	fi
}

edit_fstab()
{
	local MESAGE="\
Here you can specify the parameters for mounting the hard
drive to fine-tune them. Parameters: errors=remount-ro
is best left unchanged. For example, you can specify them
like this: rw,relatime,errors=remount-ro. See mount(8)
for more information."

	local NUMBER=0
	local OPTIONS=0
	local STRING=0

	echo -e "${MASAGE}\n"

	# show all lines of the file and number them
	sed -n -e '1,$p' -e '/$/=' /etc/fstab
	echo ""

	while
		echo -n "Enter string number («Q» - out): "
		read NUMBER
		[ $NUMBER != "q" ]; do
		echo -n "Enter mount options: "
		read OPTIONS
		STRING=$(awk 'FNR == '${NUMBER}' {print $4}' /etc/fstab)
		sed -i 's/'${STRING}'/'${OPTIONS}'/g' /etc/fstab
	done
}

main()
{
	check_distribution
}

main
