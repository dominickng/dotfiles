ALL = $(HOME)/.bash $(HOME)/.bashrc \
      $(HOME)/.inputrc \
      $(HOME)/.pythonrc.py \
      $(HOME)/.vim $(HOME)/.vimrc \
      $(HOME)/.inputrc \
      $(HOME)/.gdb $(HOME)/.gdbinit \
      $(HOME)/.gitconfig

.PHONY	: all unlink submodules

all	: $(ALL) submodules

unlink	:
	echo $(ALL) | xargs -n 1 unlink

submodules	:
	git submodule init vim/bundle/*
	git submodule update vim/bundle/*

$(HOME)/.%	: ./%
	-unlink $(HOME)/.$* > /dev/null 2> /dev/null
	ln -s $(CURDIR)/$* $@

