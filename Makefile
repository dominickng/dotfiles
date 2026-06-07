
OS := $(shell uname -s)
SYMLINK := ln -sfn
SANDVAULT_HOME := /Users/Shared/sv-$(USER)/user

DOTFILES = $(HOME)/.zsh $(HOME)/.zshrc $(HOME)/.zshenv \
           $(HOME)/.pythonrc.py $(HOME)/.vim $(HOME)/.vimrc \
           $(HOME)/.tmux.conf \
           $(HOME)/.gdb $(HOME)/.gdbinit $(HOME)/.gitconfig

COMMON_SYMLINKS = $(DOTFILES) \
                  $(HOME)/.config/nvim \
                  $(HOME)/.claude/CLAUDE.md $(HOME)/.claude/skills/commit \
                  $(HOME)/.codex/AGENTS.md \
                  $(HOME)/.codex/skills/commit

MAC_SYMLINKS = $(COMMON_SYMLINKS) \
               $(HOME)/.tmux-osx.conf $(HOME)/.phoenix.js \
               $(HOME)/.config/ghostty \
               $(HOME)/Library/KeyBindings/DefaultKeyBinding.dict

LINUX_SYMLINKS = $(COMMON_SYMLINKS) $(HOME)/.inputrc

COMMON = $(DOTFILES) config nvim claude codex ssh-key tpm

MAC_ONLY = ghostty keybindings fonts $(HOME)/.tmux-osx.conf \
           $(HOME)/.phoenix.js

MAC_ALL = $(COMMON) $(MAC_ONLY)

LINUX_ALL = $(COMMON) $(HOME)/.inputrc

.PHONY: all mac linux linux-bootstrap linux-packages linux-nvim linux-shell \
	ssh-key unlink destroy tpm vimplugins nvim ghostty claude codex keybindings \
	xcode homebrew packages mac-bootstrap config fonts macos sandvault

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
	mkdir -p $(HOME)/.nvm

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
		https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$$(uname -m | sed 's/aarch64/arm64/').appimage
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
	@if [ ! -f $(HOME)/.ssh/id_ed25519 ]; then \
		mkdir -p $(HOME)/.ssh && chmod 700 $(HOME)/.ssh; \
		ssh-keygen -t ed25519 -f $(HOME)/.ssh/id_ed25519 -N ""; \
		echo "SSH key generated at $(HOME)/.ssh/id_ed25519"; \
	else \
		echo "SSH key already exists, skipping"; \
	fi

tpm:
	@if [ ! -d $(HOME)/.tmux/plugins/tpm ]; then \
		mkdir -p ~/.tmux/plugins && \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi
	$(HOME)/.tmux/plugins/tpm/bin/install_plugins || true

nvim: config
	$(SYMLINK) $(CURDIR)/nvim ~/.config/nvim

ghostty: config
	$(SYMLINK) $(CURDIR)/ghostty ~/.config/ghostty

# Monaco Nerd Font (used by the Ghostty config). Monaco is Apple-proprietary so
# it can't ship as a Homebrew cask; pull the patched build from its release.
fonts:
	@if ls $(HOME)/Library/Fonts/MonacoNerdFont-*.ttf >/dev/null 2>&1; then \
		echo "Monaco Nerd Font already installed"; \
	else \
		tmp=$$(mktemp -d); \
		curl -fsSL -o $$tmp/font.zip https://github.com/thep0y/monaco-nerd-font/releases/latest/download/MonacoNerdFont.zip; \
		unzip -o -q $$tmp/font.zip -d $(HOME)/Library/Fonts; \
		rm -rf $$tmp; \
		echo "Monaco Nerd Font installed"; \
	fi

keybindings:
	mkdir -p $(HOME)/Library/KeyBindings
	$(SYMLINK) $(CURDIR)/DefaultKeyBinding.dict $(HOME)/Library/KeyBindings/DefaultKeyBinding.dict

claude:
	mkdir -p $(HOME)/.claude/skills
	$(SYMLINK) $(CURDIR)/claude/CLAUDE.md $(HOME)/.claude/CLAUDE.md
	$(SYMLINK) $(CURDIR)/claude/commit $(HOME)/.claude/skills/commit
	@which claude > /dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

codex:
	mkdir -p $(HOME)/.codex/skills
	$(SYMLINK) $(CURDIR)/codex/AGENTS.md $(HOME)/.codex/AGENTS.md
	$(SYMLINK) $(CURDIR)/claude/commit $(HOME)/.codex/skills/commit

# macOS system defaults. Not part of `make mac` - run explicitly with
# `make macos`. Some keyboard changes only take effect after re-login.

macos:
	# Keyboard: fast key repeat, enable repeat in editors, no auto text munging
	defaults write -g KeyRepeat -int 2
	defaults write -g InitialKeyRepeat -int 15
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write -g NSAutomaticCapitalizationEnabled -bool false
	defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
	defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
	defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
	# Finder: path/status bars, column view, search the current folder
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder ShowStatusBar -bool true
	defaults write com.apple.finder FXPreferredViewStyle -string clmv
	defaults write com.apple.finder FXDefaultSearchScope -string SCcf
	# Dock: small icons, left, no recents, no autohide
	defaults write com.apple.dock tilesize -int 25
	defaults write com.apple.dock orientation -string left
	defaults write com.apple.dock show-recents -bool false
	defaults write com.apple.dock autohide -bool false
	# Screenshots: save PNGs without window shadow to ~/Screenshots
	mkdir -p $(HOME)/Screenshots
	defaults write com.apple.screencapture location -string "$(HOME)/Screenshots"
	defaults write com.apple.screencapture type -string png
	defaults write com.apple.screencapture disable-shadow -bool true
	killall Finder Dock SystemUIServer || true
	@echo "Some keyboard changes take effect after you log out and back in."

# Copy selected dotfiles into the Sandvault guest home so sandboxed agents
# inherit Dom's config. Copies (not symlinks) because the repo isn't visible
# inside the sandbox. Opt-in: run `make sandvault`; no-op if sandvault is absent.

sandvault:
	@command -v sv >/dev/null 2>&1 || { echo "sandvault (sv) not installed, skipping"; exit 0; }
	mkdir -p $(SANDVAULT_HOME)/.zsh \
	         $(SANDVAULT_HOME)/.claude/skills \
	         $(SANDVAULT_HOME)/.codex/skills \
	         $(SANDVAULT_HOME)/.config \
	         $(SANDVAULT_HOME)/.sandvault/bin
	rsync -a  $(CURDIR)/sandvault/bin/   $(SANDVAULT_HOME)/.sandvault/bin/
	rsync -a  $(CURDIR)/zshrc            $(SANDVAULT_HOME)/.zshrc
	rsync -a  $(CURDIR)/zshenv           $(SANDVAULT_HOME)/.zshenv
	rsync -a  $(CURDIR)/zsh/             $(SANDVAULT_HOME)/.zsh/
	rsync -a  $(CURDIR)/gitconfig        $(SANDVAULT_HOME)/.gitconfig
	rsync -a  $(CURDIR)/pythonrc.py      $(SANDVAULT_HOME)/.pythonrc.py
	rsync -a  $(CURDIR)/tmux.conf        $(SANDVAULT_HOME)/.tmux.conf
	rsync -a  $(CURDIR)/nvim/            $(SANDVAULT_HOME)/.config/nvim/
	rsync -aL $(CURDIR)/claude/CLAUDE.md $(SANDVAULT_HOME)/.claude/CLAUDE.md
	rsync -a  $(CURDIR)/claude/commit/   $(SANDVAULT_HOME)/.claude/skills/commit/
	rsync -aL $(CURDIR)/codex/AGENTS.md $(SANDVAULT_HOME)/.codex/AGENTS.md
	rsync -a  $(CURDIR)/claude/commit/   $(SANDVAULT_HOME)/.codex/skills/commit/

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
