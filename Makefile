# On some systems if not explicitly given, make uses /bin/sh
SHELL := /bin/bash

.PHONY: build install uninstall

USER_NAME := `grep "video" /etc/group | cut -d":" -f4`

BINDIR ?= /usr/bin
ROOTDIR ?= /root
HOMEDIR ?= /home/$(USER_NAME)
CONFDIR ?= /etc

INSTALL = install
MAKE = @make
ECHO = @echo
SED = @sed
CHMOD = @chmod
REMOVE = @rm
IF = @if
THEN = @then
FI = @fi

build:
	$(ECHO) "Nothing to build"
	
install:
	$(INSTALL) mare $(BINDIR)/
	$(MAKE) -C scripts install DESTDIR=$(DESTDIR)
	$(INSTALL) .bash_logout $(ROOTDIR)/
	$(INSTALL) .bashrc $(ROOTDIR)/
	$(INSTALL) .profile $(ROOTDIR)/
	$(INSTALL) .bash_logout $(HOMEDIR)/
	$(INSTALL) .bashrc $(HOMEDIR)/
	$(INSTALL) .profile $(HOMEDIR)/
	$(SED) -i 's/01;31/01;32/' $(HOMEDIR)/.bashrc
	$(INSTALL) 00-welcome-header $(CONFDIR)/update-motd.d/
	$(CHMOD) -x $(CONFDIR)/update-motd.d/00-welcome-header
	$(INSTALL) 10-system-info $(CONFDIR)/update-motd.d/
	$(CHMOD) -x $(CONFDIR)/update-motd.d/10-system-info
	$(INSTALL) 20-connect-info $(CONFDIR)/update-motd.d/
	$(CHMOD) -x $(CONFDIR)/update-motd.d/20-connect-info
	$(INSTALL) 06_mare_theme $(CONFDIR)/grub.d/
	$(CHMOD) -x $(CONFDIR)/grub.d/06_mare_theme
	$(MAKE) -C data install DESTDIR=$(DESTDIR)
	
uninstall:
	$(ECHO) "uninstall /usr/bin/mare"
	$(REMOVE) -f $(BINDIR)/mare
	$(MAKE) -C scripts uninstall DESTDIR=$(DESTDIR)
	$(IF) [ -f /etc/update-motd.d/00-welcome-header ] \
	$(THEN) \
	$(ECHO) "uninstall /etc/update-motd.d/00-welcome-header" \
	$(REMOVE) -f $(CONFDIR)/update-motd.d/00-welcome-header \
	$(ECHO) "uninstall /etc/update-motd.d/10-system-info" \
	$(REMOVE) -f $(CONFDIR)/update-motd.d/10-system-info \
	$(ECHO) "uninstall /etc/update-motd.d/20-connect-info" \
	$(REMOVE) -f $(CONFDIR)/update-motd.d/20-connect-info \
	$(FI)
	$(IF) [ -f /etc/grub.d/06_mare_theme ] \
	$(THEN) \
	$(ECHO) "uninstall /etc/grub.d/06_mare_theme" \
	$(REMOVE) -f $(CONFDIR)/grub.d/06_mare_theme \
	$(FI)
	$(MAKE) -C data uninstall DESTDIR=$(DESTDIR)
