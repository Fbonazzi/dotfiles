#!/usr/bin/make
#
# Install components to the user's home directory using GNU stow.
SHELL := /bin/bash
OLD_DOTFILES = ${HOME}/.old-dotfiles
TARGETS = $(shell find . -maxdepth 1 -mindepth 1 -type d -name "[^\.]*" | sed 's/\.\///')
STOW := $(shell command -v stow 2> /dev/null)

$(shell mkdir -p $(OLD_DOTFILES))

.PHONY: all $(TARGETS) reset-all

define save-old
	@if [[ ! -d "$(OLD_DOTFILES)/$1" ]];\
	then\
		mkdir "$(OLD_DOTFILES)/$1";\
		for i in $$(find "./$1" -maxdepth 1 -mindepth 1);\
		do\
			if [[ -e "${HOME}/$${i##*/}" ]];\
			then\
				mv "${HOME}/$${i##*/}" "$(OLD_DOTFILES)/$1/";\
			fi\
		done\
	fi
endef

define reset-old
	@if [[ -d "$(OLD_DOTFILES)" ]];\
	then\
		for i in $$(find "$(OLD_DOTFILES)" -maxdepth 1 -mindepth 1);\
		do\
			shopt -s dotglob;\
			mv "$(OLD_DOTFILES)/$$i/*" "${HOME}/";\
			shopt -u dotglob;\
			rmdir "$$i"
		done\
	fi
endef

all: $(TARGETS)

$(TARGETS): %:
ifndef STOW
    $(error "Command 'stow' not found, but can be installed with:\
	\
	sudo apt install stow")
endif
ifeq ($(filter $@,$(TARGETS)),$@)
	$(call save-old,$@)
	stow --restow --target="${HOME}" $@
else
	$(info $@ is not a valid stow target)
endif

reset-all:
	stow --delete --target="${HOME}" $(TARGETS)
	$(call reset-old)
