#!/bin/sh
#
# Bootstrap a brand-new Mac or Debian/Ubuntu machine with these dotfiles.
#
# Run on a fresh machine with (tries curl, falls back to wget):
#
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/dominickng/dotfiles/main/bootstrap.sh || wget -qO- https://raw.githubusercontent.com/dominickng/dotfiles/main/bootstrap.sh)"
#
# It installs the minimum prerequisites, clones the repo to $HOME/dotfiles over
# HTTPS, helps you add an SSH key to GitHub, switches the remote to SSH, and
# delegates the rest to `make`.

set -eu

HTTPS_URL="https://github.com/dominickng/dotfiles.git"
SSH_URL="git@github.com:dominickng/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
SSH_KEY="$HOME/.ssh/id_ed25519"

log() {
  printf '\n\033[1;34m==>\033[0m %s\n' "$*"; 
}

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Darwin|Linux) ;;
  *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

# Install prerequisites
install_prereqs_mac() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode command line tools already installed"
    return
  fi
  log "Installing Xcode command line tools (this provides git)"
  xcode-select --install || true
  echo "    A dialog has opened — click 'Install' and accept the license."
  echo "    Waiting for the installation to finish..."
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
  log "Xcode command line tools installed"
}

install_prereqs_linux() {
  log "Installing prerequisites (git, curl) via apt"
  sudo apt-get update
  sudo apt-get install -y git curl
}

if [ "$OS" = "Darwin" ]; then
  install_prereqs_mac
else
  install_prereqs_linux
fi

# Generate SSH key and hand off to GitHub
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$SSH_KEY" ]; then
  log "Generating SSH key ($SSH_KEY)"
  ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$SSH_KEY" -N ""
else
  log "SSH key already exists ($SSH_KEY)"
fi

log "Add this SSH public key to GitHub:"
echo
cat "$SSH_KEY.pub"
echo
echo "    Add it at: https://github.com/settings/ssh/new"
if [ "$OS" = "Darwin" ]; then
  pbcopy < "$SSH_KEY.pub" && echo "    (copied to your clipboard)"
  open "https://github.com/settings/ssh/new" || true
fi
echo "    You can do this now while the install runs — it's verified at the end."

# Clone or update the repo
if [ -d "$DOTFILES_DIR" ]; then
  log "$DOTFILES_DIR already exists — pulling latest"
  git -C "$DOTFILES_DIR" pull --ff-only
else
  log "Cloning dotfiles to $DOTFILES_DIR"
  git clone "$HTTPS_URL" "$DOTFILES_DIR"
fi

# Run make
log "Running make (installs packages, neovim, and symlinks configs)"
make -C "$DOTFILES_DIR"

# macOS App Store apps. mas can no longer sign in from the CLI (Apple removed
# that), so open the App Store, wait for the user to sign in, then install.
if [ "$OS" = "Darwin" ] && command -v mas >/dev/null 2>&1; then
  mas_apps="1615798039 1569813296"  # ReadKit, 1Password for Safari
  attempt=0
  while ! mas account >/dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge 3 ]; then
      log "Not signed in to the App Store — skipping. Install later with:"
      echo "      mas install $mas_apps"
      mas_apps=""
      break
    fi
    log "Sign in to the App Store to install ReadKit and 1Password for Safari"
    open -a "App Store" || true
    printf '    Press Enter once signed in (or to retry)... '
    read -r _
  done
  if [ -n "$mas_apps" ]; then
    log "Installing App Store apps (ReadKit, 1Password for Safari)"
    # word-split is intentional: mas install takes multiple ids
    # shellcheck disable=SC2086
    mas install $mas_apps || true
  fi
fi

# Verify SSH and switch the remote to SSH
verify_ssh() {
  ssh -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 \
    | grep -q "successfully authenticated"
}

log "Verifying GitHub SSH access"
attempt=0
until verify_ssh; do
  attempt=$((attempt + 1))
  if [ "$attempt" -ge 3 ]; then
    echo "    SSH verification still failing. Add the key shown above to GitHub"
    echo "    and switch the remote later with:"
    echo "      git -C $DOTFILES_DIR remote set-url origin $SSH_URL"
    exit 0
  fi
  echo "    Couldn't authenticate to GitHub over SSH yet."
  printf '    Add the key shown above to GitHub, then press Enter to retry... '
  read -r _
done

log "SSH access confirmed — switching remote to SSH"
git -C "$DOTFILES_DIR" remote set-url origin "$SSH_URL"

log "Done! Restart your shell (or log out and back in) to load the new config."
