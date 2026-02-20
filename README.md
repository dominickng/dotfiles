# dotfiles

Personal dotfiles for macOS and Linux. Managed with `make`.

## Install

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
| `slate` | Slate window manager config (macOS) |
| `phoenix.js` | Phoenix window manager config (macOS) |
| `bash/` | Bash config |
| `gdb/`, `gdbinit` | GDB config and pretty-printers |
| `pythonrc.py` | Python REPL config |
| `inputrc` | Readline config (Linux) |
| `claude/` | Claude Code skills and config |

## Makefile targets

| Target | Description |
|---|---|
| `make all` | Auto-detect OS and run mac or linux |
| `make mac` | Full macOS setup |
| `make linux` | Full Linux setup |
| `make nvim` | Symlink Neovim config only |
| `make ghostty` | Symlink Ghostty config only (macOS) |
| `make keybindings` | Symlink `DefaultKeyBinding.dict` (macOS) |
| `make tpm` | Install tmux plugin manager |
| `make claude` | Symlink Claude config and install claude CLI |
| `make ssh-key` | Generate SSH key if one doesn't exist |
| `make unlink` | Remove symlinks |