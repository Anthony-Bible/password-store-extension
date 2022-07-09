PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions
MANDIR ?= $(PREFIX)/share/man
BASHCOMPDIR ?= /etc/bash_completion.d
uname=$(shell uname -s)
user=$(SUDO_USER)
user ?= $(USER)
# ifndef user
# 	user=$(USER)
# endif
# ifeq ($(strip $(user)),)
#   user:=$(USER)
# endif

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
	@echo "$(SUDO_USER)"
	@echo "${USER}"
	@echo "pass-share is installed successfully $(user)"
	@echo "To use pass-share run"
	@echo $(user_shell)
	@echo "echo \"export PASSWORD_STORE_EXTENSIONS_ENABLED=true\" >> ~/.bashrc"
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
	@echo "echo \"export PASSWORD_STORE_EXTENSIONS_ENABLED=true\" >> ~/.bashrc"
    else "$(user_shell)""zsh"
	@echo "echo \"export PASSWORD_STORE_EXTENSIONS_ENABLED=true\" >> ~/.zshrc"
    else
	@echo "set PASSWORD_STORE_EXTENSIONS_ENABLED=true to use password-share"
    endif

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/share.bash" \
		"$(DESTDIR)$(MANDIR)/man1/pass-share.1" 

lint:
	shellcheck -s bash share.bash

.PHONY: install uninstall lint

