.PHONY: install uninstall

MODULES ?= /usr/lib

MKDIR = @mkdir
INSTALL = install
ECHO = @echo
REMOVE = @rm

install:
	$(MKDIR) -p $(MODULES)/mare
	$(INSTALL) codecs.sh $(MODULES)/mare
	$(INSTALL) dm.sh $(MODULES)/mare
	$(INSTALL) nvidia.sh $(MODULES)/mare
	$(INSTALL) grub.sh $(MODULES)/mare
	$(INSTALL) motd.sh $(MODULES)/mare
	$(INSTALL) netman.sh $(MODULES)/mare
	$(INSTALL) optimization.sh $(MODULES)/mare
	$(INSTALL) packages.sh $(MODULES)/mare
	$(INSTALL) sources.py $(MODULES)/mare
	$(INSTALL) stifaces.sh $(MODULES)/mare
	$(INSTALL) sudo.sh $(MODULES)/mare

uninstall:
	$(ECHO) "uninstall /usr/lib/mare/codecs.sh"
	$(REMOVE) -f /usr/lib/mare/codecs.sh
	$(ECHO) "uninstall /usr/lib/mare/dm.sh"
	$(REMOVE) -f /usr/lib/mare/dm.sh
	$(ECHO) "uninstall /usr/lib/mare/nvidia.sh"
	$(REMOVE) -f /usr/lib/mare/nvidia.sh
	$(ECHO) "uninstall /usr/lib/mare/grub.sh"
	$(REMOVE) -f /usr/lib/mare/grub.sh
	$(ECHO) "uninstall /usr/lib/mare/motd.sh"
	$(REMOVE) -f /usr/lib/mare/motd.sh
	$(ECHO) "uninstall /usr/lib/mare/netman.sh"
	$(REMOVE) -f /usr/lib/mare/netman.sh
	$(ECHO) "uninstall /usr/lib/mare/optimization.sh"
	$(REMOVE) -f /usr/lib/mare/optimization.sh
	$(ECHO) "uninstall /usr/lib/mare/packages.sh"
	$(REMOVE) -f /usr/lib/mare/packages.sh
	$(ECHO) "uninstall /usr/lib/mare/sources.py"
	$(REMOVE) -f /usr/lib/mare/sources.py
	$(ECHO) "uninstall /usr/lib/mare/stifaces.sh"
	$(REMOVE) -f /usr/lib/mare/stifaces.sh
	$(ECHO) "uninstall /usr/lib/mare/sudo.sh"
	$(REMOVE) -f /usr/lib/mare/sudo.sh
	$(ECHO) "uninstall /usr/lib/mare"
	$(REMOVE) -d /usr/lib/mare
	
