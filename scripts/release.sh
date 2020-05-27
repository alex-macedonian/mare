#!/usr/bin/env bash
#
# release.sh - shows the Mare script version
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

gettext "Mare version 3.0"; echo; echo
gettext "Copyright (C) 2019 - 2020 Alexandre Popov. All rights reserved."; echo
gettext "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."; echo
gettext "This is free software: you are free to change and redistribute it."; echo
gettext "There is NO WARRANTY, to the extent permitted by law."; echo

###################### END ######################
