# Dotfiles

Personal dotfiles managed with **GNU Stow** for version control, modularity, and reproducibility across systems.

---

## Why GNU Stow

GNU Stow manages dotfiles via **symbolic links** instead of copying files.

**Advantages:**
- Single source of truth
- Easy to add/remove config groups
- Clean `$HOME` (no duplicates)
- Safe to version control
- Fully reversible

Stow only creates/removes symlinks — it never modifies files.

---

## Repository Layout

Each **top-level directory** is a *Stow package* that mirrors `$HOME` structure.
```
.dotfiles/
├── zsh/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
├── kitty/
│   └── .config/kitty/
│       └── kitty.conf
├── git/
│   └── .gitconfig
├── starship/
│   └── .config/starship.toml
└── ideavim/
    └── .ideavimrc
```

**Example:**
- `tmux/.tmux.conf` → `$HOME/.tmux.conf`
- `kitty/.config/kitty/kitty.conf` → `$HOME/.config/kitty/kitty.conf`

---

## Usage

### Setup
```bash
cd ~/.dotfiles
stow zsh tmux kitty git starship ideavim
```

### Remove symlinks
```bash
stow -D zsh
```
This removes symlinks from `$HOME` without deleting files in `.dotfiles`.

### Workflow
1. Edit files **inside `.dotfiles`**
2. Symlinks update automatically
3. Reload application or restart
4. Commit changes to git

**Never edit symlinked files in `$HOME` directly.**

---

## System Requirements

**Required:**
- Linux
- GNU Stow
- Zsh
- Git
- Tmux

**Optional (for full functionality):**
- Kitty terminal
- Starship prompt
- Lazygit (for tmux integration)

---

## Git Configuration

### Version-controlled
- `.gitconfig` (global settings, aliases, includes)

### NOT version-controlled
- `~/.gitconfig.local` (machine-specific: credentials, signing keys)
- `~/.git-credentials`
- SSH keys or tokens

`.gitconfig` includes `.gitconfig.local` if it exists. Git creates it automatically when needed.

### New machine setup
1. Clone this repository
2. Run `stow git`
3. Authenticate (SSH key or HTTPS token)

Credentials regenerate per machine.

---

## Tmux Integration

Tmux configuration includes popup bindings for:
- **Lazygit** (`Ctrl+a` + `Ctrl+y`) — Git UI
- **Terminal** (`Ctrl+a` + `Ctrl+t`) — Quick shell
- **Dotfiles menu** (`Ctrl+a` + `d`) — Edit configs

Lazygit must be installed separately.

---

## Safety Notes

- Always `cd ~/.dotfiles` before running `stow`
- Avoid filename conflicts between packages
- Use `stow -n <package>` for dry runs

---

## Purpose

This repository is for:
- Personal system reproducibility
- Learning Linux configuration
- Clean separation of concerns
- Long-term maintainability

**Not intended for public use.** Optimized for my specific workflow.
