ALL = $(HOME)/.zsh $(HOME)/.zshrc \
      $(HOME)/.pythonrc.py $(HOME)/.vim $(HOME)/.vimrc \
      $(HOME)/.tmux.conf \
      $(HOME)/.config/ghostty \
      $(HOME)/.gdb $(HOME)/.gdbinit $(HOME)/.gitconfig \
      $(HOME)/.screenrc $(HOME)/.tmux.conf $(HOME)/.tmux-osx.conf \
      $(HOME)/.slate $(HOME)/.phoenix.js

.PHONY	: all unlink destroy tpm vimplugins nvim

all	: $(ALL) config tpm ghostty nvim claude

config:
	mkdir -p ~/.config

tpm	:
	-mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

unlink	:
	echo $(ALL) | xargs -n 1 -I@ find $(HOME) -maxdepth 1 -path @ -exec unlink {} \;

destroy	:
	-echo $(ALL) | xargs -n 1 unlink >/dev/null 2>/dev/null

nvim: config
	ln -s $(CURDIR)/nvim ~/.config/nvim

ghostty: config
	ln -s $(CURDIR)/ghostty ~/.config/ghostty

claude:
	mkdir -p $(HOME)/.claude
	ln -s $(CURDIR)/CLAUDE.md $(HOME)/.claude/CLAUDE.md

$(HOME)/.%	: ./%
	find $(HOME) -path $@ -maxdepth 1 -exec unlink {} \;
	ln -s $(CURDIR)/$* $@

