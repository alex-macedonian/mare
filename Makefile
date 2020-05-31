# On some systems if not explicitly given, make uses /bin/sh
SHELL := /bin/bash

.PHONY: build install uninstall

prefix ?= /usr/sbin
rootdir ?= /root
homedir ?= /home/$(USERNAME)
confdir ?= /etc

INSTALL = install

build:
	@echo "Nothing to build"
	
install:
	$(INSTALL) mare $(prefix)/
	$(INSTALL) .bash_logout $(rootdir)/
	$(INSTALL) .bashrc $(rootdir)/
	$(INSTALL) .profile $(rootdir)/
	$(INSTALL) .bash_logout $(homedir)/
	$(INSTALL) .bashrc $(homedir)/
	sed -i 's/01;31/01;32/' $(homedir)/.bashrc
	$(INSTALL) .profile $(homedir)/
	$(INSTALL) 00-welcome-header $(confdir)/update-motd.d/
	chmod -x $(confdir)/update-motd.d/00-welcome-header
	$(INSTALL) 10-system-info $(confdir)/update-motd.d/
	chmod -x $(confdir)/update-motd.d/10-system-info
	$(INSTALL) 20-connect-info $(confdir)/update-motd.d/
	chmod -x $(confdir)/update-motd.d/20-connect-info
	$(INSTALL) 06_mare_theme $(confdir)/grub.d/
	chmod -x $(confdir)/grub.d/05_debian_theme
	@make -C data install DESTDIR=$(DESTDIR)
	@update-grub
	
uninstall:
	@echo "uninstall /usr/sbin/mare"
	@rm -f $(prefix)/mare
	@echo "uninstall /etc/update-motd.d/00-welcome-header"
	@rm -f $(confdir)/update-motd.d/00-welcome-header
	@echo "uninstall /etc/update-motd.d/10-system-info"
	@rm -f $(confdir)/update-motd.d/10-system-info
	@echo "uninstall /etc/update-motd.d/20-connect-info"
	@rm -f $(confdir)/update-motd.d/20-connect-info
	chmod +x /etc/update-motd.d/10-uname
	@echo "uninstall /etc/grub.d/06_mare_theme"
	@rm -f $(confdir)/grub.d/06_mare_theme
	chmod +x $(confdir)/grub.d/05_debian_theme
	@make -C data uninstall DESTDIR=$(DESTDIR)
	@update-grub
