.PHONY: install uninstall

data ?= /usr/share

MKDIR = @mkdir
INSTALL = install
ECHO = @echo
REMOVE = @rm

install:
	$(MKDIR) -p $(data)/mare
	$(INSTALL) advices.list $(data)/mare/
	$(INSTALL) countries.list $(data)/mare/
	$(INSTALL) mirror.list $(data)/mare/
	$(INSTALL) package.list $(data)/mare/
	$(INSTALL) usage.list $(data)/mare/
	$(INSTALL) release.list $(data)/mare/
	$(INSTALL) version.list $(data)/mare/

uninstall:
	$(ECHO) "uninstall /usr/share/mare/advices.list"
	$(REMOVE) -f $(data)/mare/advices.list
	$(ECHO) "uninstall /usr/share/mare/countries.list"
	$(REMOVE) -f $(data)/mare/countries.list
	$(ECHO) "uninstall /usr/share/mare/mirror.list"
	$(REMOVE) -f $(data)/mare/mirror.list
	$(ECHO) "uninstall /usr/share/mare/package.list"
	$(REMOVE) -f $(data)/mare/package.list
	$(ECHO) "uninstall /usr/share/mare/usage.list"
	$(REMOVE) -f $(data)/mare/usage.list
	$(ECHO) "uninstall /usr/share/mare/release.list"
	$(REMOVE) -f $(data)/mare/release.list
	$(ECHO) "uninstall /usr/share/mare/version.list"
	$(REMOVE) -f $(data)/mare/version.list
	$(ECHO) "uninstall /usr/share/mare"
	$(REMOVE) -d $(data)/mare
