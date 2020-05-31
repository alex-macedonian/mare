#!/usr/bin/env bash
#
# grub.sh - configures bootloader operating system Debian GNU/Linux
# or LMDE
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

# Variable for checking the contents of the  /etc/default/grub file
TIMEOUT=$(awk 'FNR == 7 {print}' /etc/default/grub)

###################### BEGIN ######################

if [ "$TIMEOUT" = "GRUB_TIMEOUT=5" ]; then
	sed -i '7i\GRUB_TIMEOUT_STYLE=hidden' /etc/default/grub
	sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
	sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT=""/g' /etc/default/grub
	update-grub > /dev/null
else
	echo "The operating system bootloader is already configured."
fi

###################### END ######################
