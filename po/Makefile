.PHONY: mofile install uninstall clean

localedir ?= /usr/share/locale/ru/LC_MESSAGES

MOFILE = mofile
INSTALL = install

mofile:
	@echo "create the mare.mo file"
	@msgfmt -o mare.mo ru.po

install: $(MOFILE)
	$(INSTALL) mare.mo $(localedir)/

uninstall:
	@echo "uninstall /usr/share/locale/ru/LC_MESSAGES/mare.mo"
	@rm -f $(localedir)/mare.mo

clean:
	@echo "clean the directory"
	@rm -f mare.mo
