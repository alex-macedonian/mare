.PHONY: install uninstall

datadir ?= /usr/share

INSTALL = install

install:
	mkdir -p $(datadir)/mare/data
	$(INSTALL) countries.list $(datadir)/mare/data/
	$(INSTALL) mirror.list $(datadir)/mare/data/
	$(INSTALL) menu.list $(datadir)/mare/data/
	$(INSTALL) package.list $(datadir)/mare/data/
	$(INSTALL) usage.list $(datadir)/mare/data/
	$(INSTALL) release.list $(datadir)/mare/data/

uninstall:
	@echo "uninstall /usr/share/mare/data/countries.list"
	@rm -f $(datadir)/mare/data/countries.list
	@echo "uninstall /usr/share/mare/data/mirror.list"
	@rm -f $(datadir)/mare/data/mirror.list
	@echo "uninstall /usr/share/mare/data/menu.list"
	@rm -f $(datadir)/mare/data/menu.list
	@echo "uninstall /usr/share/mare/data/package.list"
	@rm -f $(datadir)/mare/data/package.list
	@echo "uninstall /usr/share/mare/data/usage.list"
	@rm -f $(datadir)/mare/data/usage.list
	@echo "uninstall /usr/share/mare/data/release.list"
	@rm -f $(datadir)/mare/data/release.list
	@echo "uninstall /usr/share/mare/data"
	@rm -d $(datadir)/mare/data
	@echo "uninstall /usr/share/mare"
	@rm -d $(datadir)/mare
