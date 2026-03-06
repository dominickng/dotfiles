
OS := $(shell uname -s)
SYMLINK := ln -sfn

DOTFILES = $(HOME)/.zsh $(HOME)/.zshrc \
           $(HOME)/.pythonrc.py $(HOME)/.vim $(HOME)/.vimrc \
           $(HOME)/.tmux.conf \
           $(HOME)/.gdb $(HOME)/.gdbinit $(HOME)/.gitconfig

COMMON_SYMLINKS = $(DOTFILES) \
                  $(HOME)/.config/nvim \
                  $(HOME)/.claude/CLAUDE.md $(HOME)/.claude/skills/commit

MAC_SYMLINKS = $(COMMON_SYMLINKS) \
               $(HOME)/.tmux-osx.conf $(HOME)/.slate $(HOME)/.phoenix.js \
               $(HOME)/.config/ghostty \
               $(HOME)/Library/KeyBindings/DefaultKeyBinding.dict

LINUX_SYMLINKS = $(COMMON_SYMLINKS) $(HOME)/.inputrc

COMMON = $(DOTFILES) config nvim claude ssh-key tpm

MAC_ONLY = ghostty keybindings $(HOME)/.tmux-osx.conf \
           $(HOME)/.slate $(HOME)/.phoenix.js

MAC_ALL = $(COMMON) $(MAC_ONLY)

LINUX_ALL = $(COMMON) $(HOME)/.inputrc

.PHONY: all mac linux linux-bootstrap linux-packages linux-nvim linux-shell \
	ssh-key unlink destroy tpm vimplugins nvim ghostty claude keybindings \
	xcode homebrew packages mac-bootstrap config

all:
ifeq ($(OS),Darwin)
	$(MAKE) mac
else
	$(MAKE) linux
endif

mac: mac-bootstrap $(MAC_ALL)

linux: linux-bootstrap $(LINUX_ALL)

# Mac bootstrap chain

mac-bootstrap: xcode homebrew packages

xcode:
	xcode-select --install || true

homebrew:
	@which brew > /dev/null 2>&1 || \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

packages: homebrew
	PATH=/opt/homebrew/bin:$(PATH) brew bundle --file=$(CURDIR)/Brewfile

# Linux bootstrap chain

linux-bootstrap: linux-packages linux-nvim linux-shell

linux-packages:
	sudo apt-get update
	sudo apt-get install -y \
		zsh git tmux curl wget build-essential \
		fd-find ripgrep python3 python3-pip nodejs npm \
		zsh-syntax-highlighting
	mkdir -p $(HOME)/.local/bin
	ln -sf $$(which fdfind) $(HOME)/.local/bin/fd || true

linux-nvim:
	mkdir -p $(HOME)/.local/bin
	curl -Lo $(HOME)/.local/bin/nvim \
		https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
	chmod u+x $(HOME)/.local/bin/nvim

linux-shell:
	@if [ "$${SHELL}" != "$$(which zsh)" ]; then \
		chsh -s $$(which zsh); \
		echo "Default shell set to zsh - re-login to take effect"; \
	else \
		echo "zsh is already the default shell"; \
	fi

# Shared setup

config:
	mkdir -p ~/.config

ssh-key:
	@if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		mkdir -p $(HOME)/.ssh && chmod 700 $(HOME)/.ssh; \
		ssh-keygen -t rsa -b 4096 -f $(HOME)/.ssh/id_rsa -N ""; \
		echo "SSH key generated at $(HOME)/.ssh/id_rsa"; \
	else \
		echo "SSH key already exists, skipping"; \
	fi

tpm:
	@if [ ! -d $(HOME)/.tmux/plugins/tpm ]; then \
		mkdir -p ~/.tmux/plugins && \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi

nvim: config
	$(SYMLINK) $(CURDIR)/nvim ~/.config/nvim

ghostty: config
	$(SYMLINK) $(CURDIR)/ghostty ~/.config/ghostty

keybindings:
	mkdir -p $(HOME)/Library/KeyBindings
	$(SYMLINK) $(CURDIR)/DefaultKeyBinding.dict $(HOME)/Library/KeyBindings/DefaultKeyBinding.dict

claude:
	mkdir -p $(HOME)/.claude/skills
	$(SYMLINK) $(CURDIR)/claude/CLAUDE.md $(HOME)/.claude/CLAUDE.md
	$(SYMLINK) $(CURDIR)/claude/commit $(HOME)/.claude/skills/commit
	@which claude > /dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

# Maintenance

ifeq ($(OS),Darwin)
PLATFORM_SYMLINKS = $(MAC_SYMLINKS)
else
PLATFORM_SYMLINKS = $(LINUX_SYMLINKS)
endif

unlink:
	@for f in $(PLATFORM_SYMLINKS); do \
		[ -L $$f ] && unlink $$f && echo "Removed $$f" || true; \
	done

destroy:
	-@for f in $(PLATFORM_SYMLINKS); do unlink $$f 2>/dev/null; done

$(HOME)/.%: ./%
	$(SYMLINK) $(CURDIR)/$* $@
