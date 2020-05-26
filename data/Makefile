.PHONY: install uninstall

datadir ?= /usr/share

INSTALL = install

install:
	mkdir -p $(datadir)/mare
	$(INSTALL) countries.list $(datadir)/mare/
	$(INSTALL) mirror.list $(datadir)/mare

uninstall:
	@echo "uninstall /usr/share/mare/countries.list"
	@rm -f $(datadir)/mare/countries.list
	@echo "uninstall /usr/share/mare/mirror.list"
	@rm -f $(datadir)/mare/mirror.list
	@echo "uninstall /usr/share/mare"
	@rm -d $(datadir)/mare
