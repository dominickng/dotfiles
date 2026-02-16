# We run the environment settings for all shells to ensure it's always set up
source "${HOME}/.zsh/environment"

# An interactive shell starting zshrc is not a login shell, just run
# interactive setup
if [[ -o interactive ]]; then
	source "${HOME}/.zsh/interactive"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
