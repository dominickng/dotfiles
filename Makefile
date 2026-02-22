OS := $(shell uname -s)
SYMLINK := ln -sfn

COMMON = $(HOME)/.zsh $(HOME)/.zshrc \
         $(HOME)/.pythonrc.py $(HOME)/.vim $(HOME)/.vimrc \
         $(HOME)/.tmux.conf \
         $(HOME)/.gdb $(HOME)/.gdbinit $(HOME)/.gitconfig

MAC_ONLY = $(HOME)/.config/ghostty \
           $(HOME)/.tmux-osx.conf \
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

mac: mac-bootstrap $(MAC_ALL) config tpm ghostty keybindings nvim claude ssh-key

linux: linux-bootstrap $(LINUX_ALL) config tpm nvim claude ssh-key linux-shell

ssh-key:
	@if [ ! -f $(HOME)/.ssh/id_rsa ]; then \
		mkdir -p $(HOME)/.ssh && chmod 700 $(HOME)/.ssh; \
		ssh-keygen -t rsa -b 4096 -f $(HOME)/.ssh/id_rsa -N ""; \
		echo "SSH key generated at $(HOME)/.ssh/id_rsa"; \
	else \
		echo "SSH key already exists, skipping"; \
	fi

config:
	mkdir -p ~/.config

tpm:
	@if [ ! -d $(HOME)/.tmux/plugins/tpm ]; then \
		mkdir -p ~/.tmux/plugins && \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi

unlink:
	echo $(MAC_ALL) | xargs -n 1 -I@ find $(HOME) -maxdepth 1 -path @ -exec unlink {} \;

destroy:
	-echo $(MAC_ALL) | xargs -n 1 unlink >/dev/null 2>/dev/null

nvim: config
	$(SYMLINK) $(CURDIR)/nvim ~/.config/nvim

ghostty: config
	$(SYMLINK) $(CURDIR)/ghostty ~/.config/ghostty

keybindings:
	mkdir -p $(HOME)/Library/KeyBindings
	$(SYMLINK) $(CURDIR)/DefaultKeyBinding.dict $(HOME)/Library/KeyBindings/DefaultKeyBinding.dict

claude:
	mkdir -p $(HOME)/.claude
	$(SYMLINK) $(CURDIR)/CLAUDE.md $(HOME)/.claude/CLAUDE.md
	@which claude > /dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

xcode:
	xcode-select --install || true

homebrew:
	@which brew > /dev/null 2>&1 || \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

packages: homebrew
	brew bundle --file=$(CURDIR)/Brewfile

mac-bootstrap: xcode homebrew packages

linux-bootstrap: linux-packages linux-nvim

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

$(HOME)/.%: ./%
	$(SYMLINK) $(CURDIR)/$* $@
