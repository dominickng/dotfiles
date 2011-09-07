ALL = $(HOME)/.bash $(HOME)/.bashrc \
      $(HOME)/.inputrc \
      $(HOME)/.pythonrc.py \
      $(HOME)/.vim $(HOME)/.vimrc \
      $(HOME)/.inputrc \
      $(HOME)/.gdb $(HOME)/.gdbinit

.PHONY	: all unlink

all	: $(ALL)

unlink	:
	echo $(ALL) | xargs -n 1 unlink

$(HOME)/.%	: ./%
	-unlink $(HOME)/.$* > /dev/null
	ln -s $(CURDIR)/$* $@

