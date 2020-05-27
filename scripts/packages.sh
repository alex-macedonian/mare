#!/usr/bin/env bash
#
# packges.sh - sets up additional packages for Debian GNU/Linux
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
PACKAGE_NAME=0
FILE=0
FIREFOX_PACKAGE=$(dpkg -l 2> /dev/null | grep firefox-esr | awk 'FNR == 1 {print $2}')
LIBREOFFICE_CORE_PACKGE=$(dpkg -l 2> /dev/null | grep libreoffice-core | awk 'FNR == 1 {print $2}')
GIMP_PACKGE=$(dpkg -l 2> /dev/null | grep gimp | awk 'FNR == 1 {print $2}')

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

#################################
# 			FUNCTION			#
#################################

# Show a list of possible packages for installation
possible_packages() 
{

	gettext "Number 0. Package: skype."; echo
	gettext "Short description: free proprietary software with closed source,"; echo
	gettext "providing text, voice and video communication over the Internet"; echo
	gettext "between computers. You can get a detailed description of this"; echo
	gettext "program by clicking on the following link:"; echo
	gettext "https://en.wikipedia.org/wiki/Skype"; echo
	gettext "Number 1.Package: chromium."; echo
	gettext "Short description: web browser."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show chromium."; echo
	gettext "Number 2. Package: chromium-l10n."; echo
	gettext "Short description: web browser localization."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show chromium-l10n."; echo
	gettext "Number 3. Package: transmission-gtk."; echo
	gettext "Short description: BitTorrent client (GTK + interface)."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show transmission-gtk."; echo
	gettext "Number 4. Package: brasero."; echo
	gettext "Short description: CD/DVD burning for GNOME."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show brasero."; echo
	gettext "Number 5. Package: gimp."; echo
	gettext "Short description: GNU Raster Image Editor."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gimp."; echo
	gettext "Number 6. Package: blender."; echo
	gettext "Short description: fast and flexible system of three-dimensional"; echo
	gettext "modeling and rendering. You can get a detailed description of the"; echo
	gettext "package by entering the following at the command line:"; echo
	gettext "apt-cache show blender."; echo
	gettext "Number 7. Package: openshot."; echo
	gettext "Short description: create and edit videos and movies (transitional package)."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show openshot."; echo
	gettext "Number 8. Package: audacity."; echo
	gettext "Short description: fast cross platform sound editor."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show audacity."; echo
	gettext "Number 9. Package: mixxx."; echo
	gettext "Short description: Digital Disc Jockey Interface."
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show mixxx."; echo
	gettext "Number 10. Package: dmz-cursor-theme."; echo
	gettext "Short description: Style neutral, scalable cursor theme."
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show dmz-cursor-theme."; echo
	gettext "Number 11. Package: numix-gtk-theme."; echo
	gettext "Short description: modern flat theme from the Numix project."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show numix-gtk-theme."; echo
	gettext "Number 12. Package: adapta-gtk-theme."; echo
	gettext "Short description: Adaptive Gtk+ theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show adapta-gtk-theme."; echo
	gettext "Number 13. Package: materia-gtk-theme."; echo
	gettext "Short description: Material Design theme for GNOME/GTK+ based"; echo
	gettext "desktop environments. You can get a detailed description of the"; echo
	gettext "package by entering the following at the command line:"; echo
	gettext "apt-cache show materia-gtk-theme."; echo
	gettext "Number 14. Package: numix-icon-theme."; echo
	gettext "Short description: modern icon theme from the Numix project."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show numix-icon-theme."; echo
	gettext "Number 15. Package: numix-icon-theme-circle."; echo
	gettext "Short description: Circle icon theme from the Numix project."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show numix-icon-theme-circle."; echo
	gettext "Number 16. Package: gnome-brave-icon-theme."; echo
	gettext "Short description: blue variant of Gnome-colors icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gnome-brave-icon-theme."; echo
	gettext "Number 17. Package: gnome-dust-icon-theme."; echo
	gettext "Short description: chocolate variant of the GNOME-Colors icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gnome-dust-icon-theme."; echo
	gettext "Number 18. Package: gnome-human-icon-theme."; echo
	gettext "Short description: orange variant of the GNOME-Colors icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gnome-human-icon-theme."; echo
	gettext "Number 19. Package: gnome-illustrious-icon-theme."; echo
	gettext "Short description: pink variant of the GNOME-Colors icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gnome-illustrious-icon-theme."; echo
	gettext "Number 20. Package: gnome-noble-icon-theme."; echo
	gettext "Short description: purple variant of the GNOME-Colors icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gnome-noble-icon-theme."; echo
	gettext "Number 21. Package: gnome-wine-icon-theme."; echo
	gettext "Short description: red variant of the GNOME-Colors icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gnome-wine-icon-theme."; echo
	gettext "Number 22. Package: gnome-wise-icon-theme."; echo
	gettext "Short description: green variant of the GNOME-Colors icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gnome-wise-icon-theme."; echo
	gettext "Number 23. Package: human-icon-theme."; echo
	gettext "Short description: Human Icon theme."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show human-icon-theme."; echo
	gettext "Number 24. Package: bleachbit."; echo
	gettext "Short description: delete unnecessary files from the system."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show bleachbit."; echo
	gettext "Number 25. Package: catfish."; echo
	gettext "Short description: tool for find files, which is customizable a command line."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show catfish."; echo
	gettext "Number 26. Package: screenfetch."; echo
	gettext "Short description: Bash Screenshot Information Tool."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show screenfetch."; echo
	gettext "Number 27. Package: inxi."; echo
	gettext "Short description: full featured system information script."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show inxi."; echo
	gettext "Number 28. Package: lshw."; echo
	gettext "Short description: hardware configuration information."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show lshw."; echo
	gettext "Number 29. Package: net-tools."; echo
	gettext "Short description: toolkit for NET-3."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show net-tools."; echo
	gettext "Number 30. Package: gvfs-backends."; echo
	gettext "Short description: user space virtual file system - drivers."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show gvfs-backends."; echo
	gettext "Number 31. Package: unrar."; echo
	gettext "Short description: unarchiver for .rar files (non-free version)."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show unrar."; echo
	gettext "Number 32. Package: lightdm-gtk-greeter-settings."; echo
	gettext "Short description: settings editor for the LightDM GTK+ Greeter."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show lightdm-gtk-greeter-settings."; echo
	gettext "Number 33. Package: dconf-editor."; echo
	gettext "Short description: simple settings storage system - graphical interface."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show dconf-editor."; echo
	gettext "Number 34. Package: ttf-mscorefonts-installer."; echo
	gettext "Short description: installer for Microsoft TrueType core fonts."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show ttf-mscorefonts-installer."; echo
	gettext "Number 35. Package: font-freefont-ttf."; echo
	gettext "Short description: free Serif, Sans, and Mono fonts in TrueType format."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show font-freefont-ttf."; echo
	gettext "Number 36. Package: fonts-noto."; echo
	gettext "Short description: metapackage to pull in all Noto fonts."; echo
	gettext "You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show fonts-noto."; echo
	gettext "Number 37. Package: fonts-noto-core."; echo
	gettext "Short description: 'No Tofu' font families with large Unicode coverage"; echo
	gettext "(core). You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show fonts-noto-core."; echo
	gettext "Number 38. Package: fonts-noto-extra."; echo
	gettext "Short description: 'No Tofu' font families with large Unicode coverage"; echo
	gettext "(extra). You can get a detailed description of the package by entering"; echo
	gettext "the following at the command line: apt-cache show fonts-noto-extra."; echo; echo

}

###################### BEGIN ######################

gettext "Installing additional packages that are not shipped with"; echo
gettext "the Debian GNU/Linux 10 operating system distribution kit."; echo
gettext "You can select any package from the list for its subsequent"; echo
gettext "installation."; echo; echo

# preparation for installing additional packages
# create a directory to store temporary files
mkdir -p /tmp/mare 
# show a list of possible packages for installation
possible_packages

# create files containing package names for installation
while
	gettext "Enter a package number («Q» - out): "
	read NUMBER 
	[ "$NUMBER" != "q" ]; do
	PACKAGE_NAME=$(dpkg -l 2> /dev/null | grep ${possible_packages[$NUMBER]} | awk 'FNR == 1 {print $2}')
	if [ "$PACKAGE_NAME" = "${possible_packages[$NUMBER]}" ]; then
		gettext "This package is already installed on your system."; echo
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
	
# install help and localization packages for some programs according to
# the regional settings of the system
if [ -n "$FIREFOX_PACKAGE" ]; then
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
	
# clean up garbage after installing packages
gettext "Cleaning the system from unnecessary files and directories."; echo	
rm -R /tmp/mare
apt-get -y clean > /dev/null

###################### END ######################
