ALL = $(HOME)/.bash $(HOME)/.bashrc \
      $(HOME)/.inputrc \
      $(HOME)/.pythonrc.py \
      $(HOME)/.vim $(HOME)/.vimrc \
      $(HOME)/.inputrc \
      $(HOME)/.gdb $(HOME)/.gdbinit \
      $(HOME)/.gitconfig $(HOME)/.screenrc

.PHONY	: all unlink submodules destroy

all	: $(ALL) submodules

unlink	:
	echo $(ALL) | xargs -n 1 -I@ find $(HOME) -maxdepth 1 -path @ -exec unlink {} \;

destroy	:
	-echo $(ALL) | xargs -n 1 unlink >/dev/null 2>/dev/null

submodules	:
	git submodule init vim/bundle/*
	git submodule update vim/bundle/*
	git submodule foreach git pull origin master

$(HOME)/.%	: ./%
	find $(HOME) -path $@ -maxdepth 1 -exec unlink {} \;
	ln -s $(CURDIR)/$* $@

