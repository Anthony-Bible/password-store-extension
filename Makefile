PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions
MANDIR ?= $(PREFIX)/share/man
BASHCOMPDIR ?= /etc/bash_completion.d
uname=$(shell uname -s)
user=$(SUDO_USER)
user ?= $(USER)

ifeq "$(uname)" "Darwin"
user_shell=$(shell finger $(user) | grep -o 'Shell: .*' | awk -F"/" '{print $$NF}')
else
user_shell=$(shell getent passwd $(user) | awk -F/ '{print $$NF}')
endif
all:
	@echo "pass-share is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo
	@echo "To run pass share one needs to have some tools installed on the system:"
	@echo "     password store"
	@echo "     curl"

install:

    ifeq "$(uname)" "Darwin"
	@install -v -d /usr/local/share/man/man1
	@install -v -m 0644 man/pass-extension-share.1 /usr/local/share/man/man1/pass-share.1
	@install -v -d "$(shell brew --prefix)/lib/password-store/extensions"
	@install -v -m 0755 share.bash "$(shell brew --prefix)/lib/password-store/extensions/share.bash"
	@echo 
	@echo 
	@echo "pass-share is installed successfully $(user)"
	@echo "To use pass-share run"
	@echo
	@echo 
	@echo
    else
	@install -v -d "$(DESTDIR)$(MANDIR)/man1"
	@install -v -m 0644 man/pass-extension-share.1 "$(DESTDIR)$(MANDIR)/man1/pass-share.1"
	@install -v -d "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/"
	@install -v -m0755 share.bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/share.bash"
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)/"
	@echo
	@echo 
	@echo
	@echo "pass-share is installed successfully"
	@echo 
	@echo
    endif
    ifeq "$(user_shell)" "bash"
	@echo "Run the folowing to use pass-share:"
	@echo "echo \"export PASSWORD_STORE_EXTENSIONS_ENABLED=true\" >> ~/.bashrc"
	@echo
    else ifeq "$(user_shell)" "zsh"
	@echo "Run the folowing to use pass-share:"
	@echo "echo \"export PASSWORD_STORE_EXTENSIONS_ENABLED=true\" >> ~/.zshrc"
	@echo
    else
	@echo "set PASSWORD_STORE_EXTENSIONS_ENABLED=true to use password-share"
	@echo 
    endif

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/share.bash" \
		"$(DESTDIR)$(MANDIR)/man1/pass-share.1" 

lint:
	shellcheck -s bash share.bash

.PHONY: install uninstall lint

