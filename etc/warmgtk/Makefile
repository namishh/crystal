PREFIX = /usr
DESTDIR ?=
INSTALL_DIR ?= $(DESTDIR)$(PREFIX)/share/themes/phocus

all:
	npm install && npm run build

install:
	@install -v -d "$(INSTALL_DIR)"
	@install -m 0644 -v index.theme "$(INSTALL_DIR)"
	@cp -rv assets gtk-3.0 "$(INSTALL_DIR)"

uninstall:
	@rm -vrf "$(INSTALL_DIR)"

.PHONY: all install uninstall
