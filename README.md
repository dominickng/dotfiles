# dotfiles

Personal dotfiles for macOS and Linux. Managed with `make`.

## Install

On a brand-new Mac or Debian/Ubuntu machine, run (tries `curl`, falls back to
`wget` — needs one of them present to fetch the script):

```sh
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/dominickng/dotfiles/main/bootstrap.sh || wget -qO- https://raw.githubusercontent.com/dominickng/dotfiles/main/bootstrap.sh)"
```

This installs prerequisites, helps you add an SSH key to GitHub, clones the repo
to `~/dotfiles`, and runs `make`.

Or do it manually:

```sh
git clone <this repo> ~/dotfiles
cd ~/dotfiles
make
```

`make` detects the OS and runs either `make mac` or `make linux`.

### macOS

Installs Xcode CLI tools, Homebrew, and packages from `Brewfile`, then
symlinks everything:

```sh
make mac
```

### Linux (Ubuntu/Debian)

Installs packages via `apt`, downloads the latest Neovim AppImage, and
symlinks everything:

```sh
make linux
```

## What's included

| Config | Description |
|---|---|
| `zsh/` | Zsh config and plugins |
| `nvim/` | Neovim config (Lua, lazy.nvim) |
| `tmux.conf` | Tmux config |
| `tmux-osx.conf` | macOS-specific tmux overrides |
| `ghostty/` | Ghostty terminal config (macOS) |
| `gitconfig` | Git config |
| `DefaultKeyBinding.dict` | macOS system-wide keybindings (Emacs-style word movement) |
| `phoenix.js` | Phoenix window manager config (macOS) |
| `bash/` | Bash config |
| `gdb/`, `gdbinit` | GDB config and pretty-printers |
| `pythonrc.py` | Python REPL config |
| `inputrc` | Readline config (Linux) |
| `claude/` | Claude Code skills and config |
| `codex/` | Codex skills and config |

## Makefile targets

| Target | Description |
|---|---|
| `make all` | Auto-detect OS and run mac or linux |
| `make mac` | Full macOS setup |
| `make linux` | Full Linux setup |
| `make nvim` | Symlink Neovim config only |
| `make ghostty` | Symlink Ghostty config only (macOS) |
| `make fonts` | Install the Monaco Nerd Font (macOS) |
| `make keybindings` | Symlink `DefaultKeyBinding.dict` (macOS) |
| `make tpm` | Install tmux plugin manager and its plugins |
| `make claude` | Symlink Claude config and install claude CLI |
| `make ssh-key` | Generate SSH key if one doesn't exist |
| `make macos` | Apply macOS system defaults (not run by `make mac`) |
| `make unlink` | Remove symlinks |

`make macos` is intentionally separate from `make mac` — it changes system
preferences and restarts Finder/Dock.
