#!/usr/bin/python3
#
# Based on https://github.com/linuxmint/mintsources/blob/master/usr/lib/linuxmint/mintSources/mintSources.py
#
# sources.py - configures package sources and update the operating
# system Debian GNU/Linux
#
# Copyright (C) 2020 Alexandre Popov <consiorp@gmail.com>.
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

import os
import re
import sys
import pycurl
import datetime
import subprocess

from io import BytesIO

def check_distribution():

	distro = subprocess.getoutput("grep -m 1 -o 'Debian' /usr/share/mare/version.list")
	if len(distro) == 0:
		print("mare: you are using a different distribution GNU/Linux")
	else:
		shell()
	
def shell():

	words = subprocess.getoutput("grep -m 1 -o 'non-free' /etc/apt/sources.list")
	if words == "non-free":
		print("Package sources are is already configured.")
	else:
		configure_package_sources()

def configure_package_sources():
	"""Configure package sources and update system."""
		
	# check the status of network interfaces
	state_ifaces()

	# if this file exists, then delete it
	base_list = os.path.exists("/etc/apt/sources.list.d/base.list")
	if base_list is True:
		os.remove("/etc/apt/sources.list.d/base.list")

	edit_sources_list()

def state_ifaces():
	"""Check the status of network interfaces."""

	state_wired_iface = os.system("ip a | awk 'FNR == 7 {print $9}'")
	state_wireless_iface = os.system("ip a | awk 'FNR == 9 {print $9}'")

	if state_wired_iface == "DOWN" or state_wireless_iface == "DOWN":
		print("mare: network connection not established.")

		if state_wired_iface == "DOWN":
			print("Perhaps the network cable disconnected.")

		if state_wireless_iface == "DOWN":
			print("You may have entered the wrong access point name or password.")
		sys.exit(1)

def edit_sources_list():
	cdrom = subprocess.getoutput("grep -m 1 '# deb cdrom:' /etc/apt/sources.list")
	url = check_entered_mirror()
	codename = subprocess.getoutput("lsb_release -sc")

	with open("/etc/apt/sources.list", "w") as f:
		f.write("#\n")
		f.write(" \n")
		f.write("%s\n" % (cdrom))
		f.write(" \n")
		f.write("%s\n" % (cdrom))
		f.write(" \n")
		f.write("deb http://security.debian.org/debian-security %s/updates main contrib non-free\n" % (codename))
		f.write("# deb-src http://security.debian.org/debian-security %s/updates main contrib non-free\n" % (codename))
		f.write(" \n")
		f.write("deb %s %s-updates main contrib non-free\n" % (url, codename))
		f.write("# deb-src %s %s-updates main contrib non-free\n" % (url, codename))
		f.write(" \n")
		f.write("deb %s %s main contrib non-free\n" % (url, codename))
		f.write("# deb-src %s %s main contrib non-free" % (url, codename))

	subprocess.call(["apt", "update"])
	subprocess.call(["apt", "-y", "upgrade"])

def check_entered_mirror():

	country = check_entered_country()
	f = open("/usr/share/mare/mirror.list", "r")
	for line in f:
		match = re.findall("%s.*" % (country), "%s" % (line))
		# if an empty list is found, then delete it
		if len(match) == 0:
			del match
		else:
			list_url = re.findall("htt.*/debian/", "%s" % (match))
			speed_test(country, list_url)
	f.close()

	print("\nChoosing a Debian repository mirror. When choosing")
	print("it, be guided by the highest data transfer rate.\n")

	while True:
		url = input("Enter mirror: ")
		check_url = subprocess.getoutput("grep -o '%s' /usr/share/mare/mirror.list" % (url))
		# if the line is empty, then show an error message
		if len(check_url) == 0:
			print("mare: this mirror is not in the list of available mirrors")
			print("Check your entered string and try to enter mirror again.")
		else:
			# return checked mirror
			return check_url

def check_entered_country()
	
	# show list of countries in alphabetical order
	with open("/usr/share/mare/countries.list", "r") as f:
		show = f.read()
		sys.stdout.write(show)

	while True:
		country = input("Enter your country: ")
		sys.stdout.write("\n")
		checking_coutnries = subprocess.getoutput("grep -m 1 -o '%s' /usr/share/mare/mirror.list" % (country))
		# if the line is empty, then show an error message
		if len(checking_coutnries) == 0:
			print("mare: for your a country's the mirror is not found")
			print("Please indicate the country closest to you.\n")
		else:
			return country
			break

def speed_test(country, list_url):
	"""Calculate average data transfer rate in bytes/sec."""

	download_speed = 0
	up_to_date = False
	url = "".join(list_url)
	codename = subprocess.getoutput("lsb_release -sc")
	test_url = "%sdists/%s/main/binary-amd64/Packages.gz" % (url, codename)
	up_to_date = check_mirror_up_to_date("%sls-lR.gz" % url, 14)

	try:
		if up_to_date is True:
			buffer = BytesIO()
			c = pycurl.Curl()
			c.setopt(c.URL, test_url)
			c.setopt(c.CONNECTTIMEOUT, 5)
			c.setopt(c.TIMEOUT, 10)
			c.setopt(c.FOLLOWLOCATION, 1)
			c.setopt(c.WRITEDATA, buffer)
			c.setopt(c.NOSIGNAL, 1)
			c.perform()
			download_speed = c.getinfo(c.SPEED_DOWNLOAD)
			c.close()
		else:
			# the mirror is not up to date
			download_speed = -1
	except pycurl.error:
		download_speed = 0

	represented_speed = get_speed_test_label(download_speed)
	show_data_rate_result = indents_in_string(country, url, represented_speed)
	return show_data_rate_result

def check_mirror_up_to_date(url, max_age):
	mirror_timestamp = get_url_last_modified(url)
	if mirror_timestamp is None:
		print ("mare: can't find the age of %s !!" % url)
		return False

	mirror_date = datetime.datetime.fromtimestamp(mirror_timestamp)
	default_mirror_date = datetime.datetime.fromtimestamp(mirror_timestamp)
	mirror_age = (default_mirror_date - mirror_date).days

	if mirror_age > max_age:
		print("mare: %s is out of date by %d days!" % (url, mirror_age))
		return False
	else:
		# Age is fine :)
		return True

def get_url_last_modified(url):
	try:
		c = pycurl.Curl()
		c.setopt(c.URL, url)
		c.setopt(c.CONNECTTIMEOUT, 5)
		c.setopt(c.TIMEOUT, 10)
		c.setopt(c.FOLLOWLOCATION, 1)
		c.setopt(c.NOBODY, 1)
		c.setopt(c.OPT_FILETIME, 1)
		c.perform()
		filetime = c.getinfo(c.INFO_FILETIME)
		c.close()
		if filetime < 0:
			return None
		else:
			return filetime
	except:
		return None

def get_speed_test_label(speed):
	"""Convert bytes to kilobytes, megabytes, gigabytes."""

	if speed > 0:
		divider = (1024 * 1.0)
		represented_speed = (speed / divider)
		unit = "kB/s"

		if represented_speed > divider:
			represented_speed = (represented_speed / divider)
			unit = "MB/s"
		if represented_speed > divider:
			represented_speed = (represented_speed / divider)
			unit = "GB/s"

		num_int_digits = len("%d" % represented_speed)
		if (num_int_digits > 2):
			represented_speed = "%d %s" % (represented_speed, unit)
		else:
			represented_speed = "%.1f %s" % (represented_speed, unit)	
	else:
		represented_speed = ("0 %s") % ("kBit/s")
	return represented_speed

def indents_in_string(country, url, represented_speed):
	"""Create in string indent left and right."""

	char = " "
	left_width = 25
	right_width = 42
	country_legnth = len(country)
	url_legnth = len(url)
	left_spaces = (left_width - country_legnth)
	right_spaces = (right_width - url_legnth)
	left_prefix = (char * left_spaces)
	right_prefix = (char * right_spaces)
	show_result = print(country, left_prefix, url, right_prefix, represented_speed)
	return show_result

def main():

	try:
		check_distribution()
	except KeyboardInterrupt:
		sys.stdout.write("\n")
		sys.exit(0)

main()
