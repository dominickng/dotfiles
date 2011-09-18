ALL = $(HOME)/.bash $(HOME)/.bashrc \
      $(HOME)/.inputrc \
      $(HOME)/.pythonrc.py \
      $(HOME)/.vim $(HOME)/.vimrc \
      $(HOME)/.inputrc \
      $(HOME)/.gdb $(HOME)/.gdbinit \
      $(HOME)/.gitconfig

.PHONY	: all unlink submodules destroy

all	: $(ALL) submodules

unlink	:
	echo $(ALL) | xargs -n 1 -I@ find $(HOME) -path @ -maxdepth 1 -exec unlink {} \;

destroy	:
	echo "Are you sure you want to force unlink all dotfiles? (Yn)"
	read a
	if [[ $a == [Yy] ]]; then
		echo $(ALL) | xargs -n 1 unlink
	else
		echo "Not destroying"
	fi

submodules	:
	git submodule init vim/bundle/*
	git submodule update vim/bundle/*

$(HOME)/.%	: ./%
	find $(HOME) -path $@ -maxdepth 1 -exec unlink {} \;
	ln -s $(CURDIR)/$* $@

