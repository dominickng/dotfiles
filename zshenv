#! zsh

# Flag when we're running inside a Sandvault sandbox (user is sandvault-<name>)
[ "${USER:0:9}" = "sandvault" ] && export SANDVAULT=1

# Put the swift/xcodebuild shims first on PATH inside a Sandvault. Interactive
# shells re-apply this in ~/.zsh/local, which rebuilds PATH from scratch.
if [ -n "${SANDVAULT}" ] && [ -d "${HOME}/.sandvault/bin" ]; then
	case ":${PATH}:" in
		*":${HOME}/.sandvault/bin:"*) ;;
		*) export PATH="${HOME}/.sandvault/bin:${PATH}" ;;
	esac
fi
