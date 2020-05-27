#!/usr/bin/env bash
#
# help.sh - shows a brief help on the commands for the Mare script
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

###################### BEGIN ######################

gettext "Performs various settings in Debian GNU/Linux 10 after installation."; echo
gettext "Namely:"; echo
gettext "  configures wireless network;"; echo
gettext "  creates a new Wi-Fi connection after rebooting the system;"; echo
gettext "  configures elevated privileges for the user;"; echo
gettext "  configures packages sources and update;"; echo
gettext "  installs micro programs for your system;"; echo
gettext "  the system by updating packages;"; echo
gettext "  configures the bootloader of the operating system;"; echo
gettext "  configures filesystems table;"; echo
gettext "  improves system performance;"; echo
gettext "  sets up additional packages;"; echo
gettext "  sets up additional codecs;"; echo
gettext "  configures the message of the day;"; echo
gettext "  configures the LightDM display manager."; echo; echo
# gettext "Report bugs at the address <bug-mare@gmail.com>"; echo

###################### END ######################
