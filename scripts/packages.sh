#!/usr/bin/env bash
#
# packges.sh - sets up additional packages for Debian GNU/Linux or LMDE
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
Installing additional packages that are not shipped with
the Debian GNU/Linux 10 operating system distribution kit.
You can select any package from the list for its subsequent
installation."

NUMBER=0
PACKAGE_NAME=0
FILE=0
LIBREOFFICE_CORE_PACKGE=$(dpkg -l 2> /dev/null | awk '$2 ~ /libreoffice-core/ {print $2}')
GIMP_PACKGE=$(dpkg -l 2> /dev/null | awk '$2 ~ /gimp/ {print $2}')

declare -a possible_packages
possible_packages[0]="skype"
possible_packages[1]="chromium"
possible_packages[2]="chromium-l10n"
possible_packages[3]="transmission-gtk"
possible_packages[4]="brasero"
possible_packages[5]="gimp"
possible_packages[6]="blender"
possible_packages[7]="openshot"
possible_packages[8]="audacity"
possible_packages[9]="mixxx"
possible_packages[10]="dmz-cursor-theme"
possible_packages[11]="numix-gtk-theme"
possible_packages[12]="adapta-gtk-theme"
possible_packages[13]="materia-gtk-theme"
possible_packages[14]="numix-icon-theme"
possible_packages[15]="numix-icon-theme-circle"
possible_packages[16]="gnome-brave-icon-theme"
possible_packages[17]="gnome-dust-icon-theme"
possible_packages[18]="gnome-human-icon-theme"
possible_packages[19]="gnome-illustrious-icon-theme"
possible_packages[20]="gnome-noble-icon-theme"
possible_packages[21]="gnome-wine-icon-theme"
possible_packages[22]="gnome-wise-icon-theme"
possible_packages[23]="human-icon-theme"
possible_packages[24]="bleachbit"
possible_packages[25]="catfish"
possible_packages[26]="screenfetch"
possible_packages[27]="inxi"
possible_packages[28]="lshw"
possible_packages[29]="net-tools"
possible_packages[30]="gvfs-backends"
possible_packages[31]="unrar"
possible_packages[32]="lightdm-gtk-greeter-settings"
possible_packages[33]="dconf-editor"
possible_packages[34]="ttf-mscorefonts-installer"
possible_packages[35]="fonts-freefont-ttf"
possible_packages[36]="fonts-noto"
possible_packages[37]="fonts-noto-core"
possible_packages[38]="fonts-noto-extra"

declare -gA language_packs
language_packs["ru_RU.UTF-8",0]="firefox-esr-l10n-ru"
language_packs["ru_RU.UTF-8",1]="libreoffice-help-ru"

declare -gA help_packs
help_packs["ru_RU.UTF-8",0]="libreoffice-help-ru"
help_packs["ru_RU.UTF-8",1]="gimp-help-ru"

###################### BEGIN ######################

# check the status of network interfaces
/usr/share/mare/stifaces.sh

echo -e "${MESAGE}\n"

# preparation for installing additional packages
# create a directory to store temporary files
mkdir -p /tmp/mare 
# show a list of possible packages for installation
cat /usr/share/mare/data/package.list

# create files containing package names for installation
while
	echo -n "Enter a package number («Q» - out): "
	read NUMBER 
	[ "$NUMBER" != "q" ]; do
	PACKAGE_NAME=$(dpkg -l 2> /dev/null | grep ${possible_packages[$NUMBER]} | awk 'FNR == 1 {print $2}')
	if [ "$PACKAGE_NAME" = "${possible_packages[$NUMBER]}" ]; then
		echo "This package is already installed on your system."
	else
		echo "${possible_packages[$NUMBER]}" > /tmp/mare/package$NUMBER
	fi
done
	
# installation of selected packages
for package in {/tmp/mare/package*}; do
	FILE=$(cat /tmp/mare/package*)
	if [ "$FILE" = "skype" ]; then
		apt-get -y install snapd
		snap install skype --classic
	else
		apt-get -y install $FILE
	fi
done

if [ "$LANG" = "ru_RU.UTF-8" ]; then
	# install help and localization packages for some programs according to
	# the regional settings of the system
	if [ -f /usr/lib/firefox-esr/firefox-esr ]; then
		apt-get -y install ${language_packs[$LANG,0]}
	fi

	if [ -n "$LIBREOFFICE_CORE_PACKGE" ]; then
		apt-get -y install ${language_packs[$LANG,1]}
	fi

	if [ -n "$LIBREOFFICE_CORE_PACKGE" ]; then
		apt-get -y install ${help_packs[$LANG,0]}
	fi
	
	if [ -n "$GIMP_PACKGE" ]; then
		apt-get -y install ${help_packs[$LANG,1]}
	fi
fi
	
# clean up garbage after installing packages
echo "Cleaning the system from unnecessary files and directories."	
rm -R /tmp/mare
apt-get -y clean > /dev/null

###################### END ######################
