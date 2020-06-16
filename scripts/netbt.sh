#!/usr/bin/env bash
#
# netbt.sh - configures USB, PCI, wired, wireless network and Bluetooth
# cards in of the operating system Debian GNU/Linux or LMDE
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

# Variable for storing the driver specified in the /proc/modules file
MODULE=0

# Variables for checking packages that support installed hardware
FIRMWARE_ATHEROS_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-atheros/ {print $2}')
ATMEL_FIRMWARE_PACKAGE=$(dpkg -l | awk '$2 ~ /atmel-firmware/ {print $2}')
FIRMWARE_BRCM80211_PACKGE=$(dpkg -l | awk '$2 ~ /firmware-brcm80211/ {print $2}')
FIRMWARE_B43_INS_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-b43-installer/ {print $2}')
FIRMWARE_B43_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-b43legacy-installer/ {print $2}')
FIRMWARE_BNX2_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-bnx2/ {print $2}')
FIRMWARE_CAVIUM_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-cavium/ {print $2}')
FIRMWARE_IPW2X00_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-ipw2x00/ {print $2}')
FIRMWARE_IWLWIFI_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-iwlwifi/ {print $2}')
FIRMWARE_LIBERTAS_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-libertas/ {print $2}')
FIRMWARE_MYRICOM_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-myricom/ {print $2}')
FIRMWARE_NETXEN_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-netxen/ {print $2}')
FIRMWARE_TI_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-ti-connectivity/ {print $2}')
FIRMWARE_INTELWIMAX_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-intelwimax/ {print $2}')
FIRMWARE_REALTEK_PACKAGE=$(dpkg -l | awk '$2 ~ /firmware-realtek/ {print $2}')

# Variable for checking the status of a wired, network interface
STATE_IFACE=$(ip a | awk 'FNR == 7 {print $9}')

# Variable to store the package name 
PACKAGE=0

# Array of possible equipment
declare -a modules
modules[0]="ar5523"
modules[1]="ath3k"
modules[2]="ath6kl_sdio"
modules[3]="ath6kl_usb"
modules[4]="ath9k_htc"
modules[5]="ath10k"
modules[6]="wilc6210"
modules[7]="at76c50x-usb"
modules[8]="brcmsmac"
modules[9]="brcmfmac"
modules[10]="b43"
modules[11]="b43legacy"
modules[12]="bnx2"
modules[13]="nitrox"
modules[14]="liquidio"
modules[15]="ipw2100"
modules[16]="ipw2200"
modules[17]="iwlegacy"
modules[18]="iwl3945"
modules[19]="iwlwifi"
modules[20]="iwlagn"
modules[21]="libertas_cs"
modules[22]="libertas_sdio"
modules[23]="libertas_spi"
modules[24]="libertas_tf_usb"
modules[25]="mwifiex_pcie"
modules[26]="mwifiex_sdio"
modules[27]="mwifiex_usb"
modules[28]="mwl8k"
modules[29]="usb8xxx"
modules[30]="myri10ge"
modules[31]="netxen_nic"
modules[32]="qlcnic"
modules[33]="wl1251"
modules[34]="wl12xx"
modules[35]="wl18xx"
modules[36]="st_drv"
modules[37]="i2400m-usb"
modules[38]="rtlwifi"

#################################
# 			FUNCTIONS			#
#################################

# Choose package to install
#choose_package()
#{
#}

# Install the selected package using the dpkg utility
install_package()
{

	local FIND_FILE=$(find / -name $PACKAGE*.deb 2> /dev/null)
	local DEPENDS=$(dpkg --info $FIND_FILE | awk '$1 ~ /Depends/ {print $2, $3, $4, $5, $6, $7}' | sed -n '2p')

	if [ -f "$FIND_FILE" ]; then
		# check package dependencies to be installed
		# if the package has dependencies, then
		if [ -n "$DEPENDS" ]; then
			echo "Put here: ${FIND_FILE}"
			echo "these packages: ${DEPENDS}"
			echo "and press enter ..."; read
			# install the package and its dependencies
			dpkg --install $FIND_FILE *
		else
			# install the package
			dpkg --install $FIND_FILE
		fi
	else
		echo "`basename $0:` the file of package micro programs is not found."
		exit 1
	fi

}

# Edit the /etc/NetworkManager/NetworkManager.conf file
edit_network_manager_conf() 
{
	
	# Variable for checking the contents of the /etc/NetworkManager/NetworkManager.conf file
	local NET_MANAGER=$(awk 'FNR == 8 {print}' /etc/NetworkManager/NetworkManager.conf)

	if [ -f /etc/NetworkManager/NetworkManager.conf ]; then
		if [ -n "$NET_MANAGER" ]; then
			echo "Random MAC address is already disabled in the NetworkManager."
		else
			sed -i '5a\ ' /etc/NetworkManager/NetworkManager.conf
			sed -i '6a\[device]' /etc/NetworkManager/NetworkManager.conf
			sed -i '7a\wifi.scan-rand-mac-address=no' /etc/NetworkManager/NetworkManager.conf
		fi
	else
		echo "`basename $0:` the NetworkManager.conf file does not exist."
	fi
	
}

###################### BEGIN ######################

for modules in ${modules[*]}; do
	# assign the MODULE variable the name of the module located in the /proc/modules file
	MODULE=$(awk '$1 ~ /'${modules}'/ {print $1}' /proc/modules)

	# choose package to install
	case "$MODULE" in
	ar5523 | ath3k | ath6kl_sdio | ath6kl_usb | ath9k_htc | ath10k | wilc6210 )
	# check, if the package is installed
	# if the package is installed, then
	# inform the user about it
	if [ -n "$FIRMWARE_ATHEROS_PACKAGE" ]; then
		echo "The firmware-atheros package is already installed on your system."
	else
		# check wired interface status
		# if wired, the network interface is connected, then
		if [ "$STATE_IFACE" = "UP" ]; then
			# configure package sources and update the system
			/usr/shere/mare/sysupdate.sh
			# install the package using apt-get utility
			apt-get -y install firmware-atheros
		else
			# give the PACKAGE variable a package name
			PACKAGE="firmware-atheros"
			# install the package using the install_package function
			install_package $PACKAGE
		fi
		
		# edit the /etc/NetworkManager/NetworkManager.conf file
		edit_network_manager_conf
	fi
	;;
	at76c50x-usb )
	if [ -n "$ATMEL_FIRMWARE_PACKAGE" ]; then
		echo "The atmel-firmware package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install atmel-firmware
		else
			PACKAGE="atmel-firmware"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	brcmsmac | brcmfmac )
	if [ -n "$FIRMWARE_BRCM80211_PACKGE" ]; then
		echo "The firmware-brcm80211 package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-brcm80211
		else
			PACKAGE="firmware-brcm80211"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	b43 )
	if [ -n "$FIRMWARE_B43_INS_PACKAGE" ]; then
		echo "The firmware-b43-installer package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-b43-installer
		else
			PACKAGE="firmware-b43-installer"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	b43legacy )
	if [ -n "$FIRMWARE_B43_PACKAGE" ]; then
		echo "The firmware-b43legacy-installer package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-b43legacy-installer
		else
			PACKAGE="firmware-b43legacy-installer"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	bnx2 )
	if [ -n "$FIRMWARE_BNX2_PACKAGE" ]; then
		echo "The firmware-bnx2 package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-bnx2
		else
			PACKAGE="firmware-bnx2"
			install_package $PACKAGE
		fi
	fi
	;;
	nitrox | liquidio )
	if [ -n "$FIRMWARE_CAVIUM_PACKAGE" ]; then
		echo "The firmware-cavium package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-cavium
		else
			PACKAGE="firmware-cavium"
			install_package $PACKAGE
		fi
	fi
	;;
	ipw2100 | ipw2200 )
	if [ -n "$FIRMWARE_IPW2X00_PACKAGE" ]; then
		echo "The firmware-ipw2x00 package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-ipw2x00
		else
			PACKAGE="firmware-ipw2x00"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	iwlegacy | iwl3945 | iwlwifi | iwlagn )
	if [ -n "$FIRMWARE_IWLWIFI_PACKAGE" ]; then
		echo "The firmware-iwlwifi package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-iwlwifi
		else
			PACKAGE="firmware-iwlwifi"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	libertas_cs | libertas_sdio | libertas_spi | libertas_tf_usb | mwifiex_pcie | mwifiex_sdio | mwifiex_usb | mwl8k | usb8xxx )
	if [ -n "$FIRMWARE_LIBERTAS_PACKAGE" ]; then
		echo "The firmware-libertas package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-libertas
		else
			PACKAGE="firmware-libertas"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	myri10ge )
	if [ -n "$FIRMWARE_MYRICOM_PACKAGE" ]; then
		echo "The firmware-myricom package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-myricom
		else
			PACKAGE="firmware-myricom"
			install_package $PACKAGE
		fi
	fi
	;;
	netxen_nic | qlcnic )
	if [ -n "$FIRMWARE_NETXEN_PACKAGE" ]; then
		echo "The firmware-netxen package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-netxen
		else
			PACKAGE="firmware-netxen"
			install_package $PACKAGE
		fi
	fi
	;;
	wl1251 | wl12xx | wl18xx | st_drv )
	if [ -n "$FIRMWARE_TI_PACKAGE" ]; then
		echo "The firmware-ti-connectivity package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-ti-connectivity
		else
			PACKAGE="firmware-ti-connectivity"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	i2400m-usb )
	if [ -n "$FIRMWARE_INTELWIMAX_PACKAGE" ]; then
		echo "The firmware-intelwimax package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-intelwimax
		else
			PACKAGE="firmware-intelwimax"
			install_package $PACKAGE
		fi
	fi
	;;
	rtlwifi )
	if [ -n "$FIRMWARE_REALTEK_PACKAGE" ]; then
		echo "The firmware-realtek package is already installed on your system."
	else
		if [ "$STATE_IFACE" = "UP" ]; then
			/usr/shere/mare/sysupdate.sh
			apt-get -y install firmware-realtek
		else
			PACKAGE="firmware-realtek"
			install_package $PACKAGE
		fi
		
		edit_network_manager_conf
	fi
	;;
	esac
done

echo "IT IS VERY IMPORTANT! Restart the computer NOW to apply the changes."
echo "Press enter ..."; read	

###################### END ######################
