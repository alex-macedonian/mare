#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# speed.py - checks the baud rate of specified URLs
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

import pycurl

from io import BytesIO
from sys import argv

if len(argv) > 1:
	country = argv[1]
	mirror = argv[2]
	
download_speed = 0

def show_aligned_data(country, mirror, represented_speed):
	char = " "
	left_width = 23
	right_width = 33
	country_legnth = len(country)
	mirror_legnth = len(mirror)
	left_spaces = (left_width - country_legnth)
	right_spaces = (right_width - mirror_legnth)
	left_prefix = (char * left_spaces)
	right_prefix = (char * right_spaces)
	show_result = print(country, left_prefix, mirror, right_prefix, represented_speed)
	return show_result

try:
	buffer = BytesIO()
	c = pycurl.Curl()
	c.setopt(c.URL, mirror)
	c.setopt(c.CONNECTTIMEOUT, 5)
	c.setopt(c.TIMEOUT, 20)
	c.setopt(c.FOLLOWLOCATION, 1)
	c.setopt(c.WRITEDATA, buffer)
	c.setopt(c.NOSIGNAL, 1)
	c.perform()
	download_speed = c.getinfo(c.SPEED_DOWNLOAD) # bytes/sec
	c.close()
except pycurl.error:
	download_speed = 0

if download_speed > 0:
	divider = (1024 * 1.0)
	represented_speed = (download_speed / divider)	# translate it to kB/S
	unit = "kB/s"
	if represented_speed > divider:
		represented_speed = (represented_speed / divider)   # translate it to MB/S
		unit = "MB/s"
	if represented_speed > divider:
		represented_speed = (represented_speed / divider)   # translate it to GB/S
		unit = "GB/s"
	num_int_digits = len("%d" % represented_speed)
	if (num_int_digits > 2):
		represented_speed = "%d %s" % (represented_speed, unit)
	else:
		represented_speed = "%.1f %s" % (represented_speed, unit)	
else:
	represented_speed = ("0 %s") % ("kB/s")

show_aligned_data(country, mirror, represented_speed)
