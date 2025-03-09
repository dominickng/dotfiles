ALL = $(HOME)/.bash $(HOME)/.bashrc $(HOME)/.inputrc \
      $(HOME)/.pythonrc.py $(HOME)/.vim $(HOME)/.vimrc \
      $(HOME)/.inputrc $(HOME)/.tmux.conf \
      $(HOME)/.gdb $(HOME)/.gdbinit $(HOME)/.gitconfig \
      $(HOME)/.screenrc $(HOME)/.tmux.conf $(HOME)/.tmux-osx.conf \
      $(HOME)/.slate $(HOME)/.phoenix.js

.PHONY	: all unlink destroy tpm vimplugins nvim

all	: $(ALL) tpm nvim

tpm	:
	-mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

unlink	:
	echo $(ALL) | xargs -n 1 -I@ find $(HOME) -maxdepth 1 -path @ -exec unlink {} \;

destroy	:
	-echo $(ALL) | xargs -n 1 unlink >/dev/null 2>/dev/null

vimplugins:
	mkdir -p ~/.vim/bundle
	git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

nvim:
	mkdir -p ~/.config
	ln -s $(CURDIR)/nvim ~/.config/nvim

$(HOME)/.%	: ./%
	find $(HOME) -path $@ -maxdepth 1 -exec unlink {} \;
	ln -s $(CURDIR)/$* $@

