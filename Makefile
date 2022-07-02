PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions
MANDIR ?= $(PREFIX)/share/man
BASHCOMPDIR ?= /etc/bash_completion.d

all:
	@echo "pass-share is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo
	@echo "To run pass share one needs to have some tools installed on the system:"
	@echo "     password store"
	@echo "     curl"

install:
	@install -v -d "$(DESTDIR)$(MANDIR)/man1"
	@install -v -m 0644 man/pass-extension-share.1 "$(DESTDIR)$(MANDIR)/man1/pass-share.1"
	@install -v -d "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/"
	@install -v -m0755 share.bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/share.bash"
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)/"
	@echo
	@echo "pass-share is installed successfully"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/share.bash" \
		"$(DESTDIR)$(MANDIR)/man1/pass-share.1" 

lint:
	shellcheck -s bash share.bash

.PHONY: install uninstall lint

