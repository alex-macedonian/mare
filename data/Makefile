.PHONY: install uninstall

datadir ?= /usr/share

INSTALL = install

install:
	mkdir -p $(datadir)/mare/data
	$(INSTALL) countries.list $(datadir)/mare/data/
	$(INSTALL) mirror.list $(datadir)/mare/data/
	$(INSTALL) menu.list $(datadir)/mare/data/
	$(INSTALL) package.list $(datadir)/mare/data/

uninstall:
	@echo "uninstall /usr/share/mare/data/countries.list"
	@rm -f $(datadir)/mare/data/countries.list
	@echo "uninstall /usr/share/mare/data/mirror.list"
	@rm -f $(datadir)/mare/data/mirror.list
	@echo "uninstall /usr/share/mare/data"
	@rm -d $(datadir)/mare/data
	@echo "uninstall /usr/share/mare"
	@rm -d $(datadir)/mare
