# We run the environment settings for all shells to ensure it's always set up
source "${HOME}/.bash/environment"

# An interactive shell starting bashrc is not a login shell, just run
# interactive setup
if [ -n "${PS1}" ]; then
	export INPUTRC=~/.inputrc
	source "${HOME}/.bash/interactive"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
