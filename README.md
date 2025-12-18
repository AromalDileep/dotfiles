

# Dotfiles

Personal dotfiles managed using **GNU Stow** to achieve a clean, modular, and reproducible system configuration.

This repository is intentionally **private** and optimized for my personal workflow.

---

## Why GNU Stow

GNU Stow manages dotfiles by creating **symbolic links** instead of copying files into `$HOME`.

### Advantages

* Single source of truth for all configuration
* Modular management (add/remove entire config groups)
* Clean `$HOME` (no duplicated files)
* Safe to version control
* Fully reversible

Stow **never edits files** — it only creates or removes symlinks.

---

## Repository Layout

Each **top-level directory** is a *Stow package*.
A package mirrors the directory structure **relative to `$HOME`**.

```
.dotfiles/
├── zsh/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
├── ghostty/
│   └── .config/ghostty/
│       └── config
├── git/
│   └── .gitconfig
├── starship/
│   └── .config/starship.toml
├── ideavim/
│   └── .ideavimrc
└── README.md
```

### Mapping examples

* `zsh/.zshrc`
  → `$HOME/.zshrc`
* `tmux/.tmux.conf`
  → `$HOME/.tmux.conf`
* `ghostty/.config/ghostty/config`
  → `$HOME/.config/ghostty/config`

Stow automatically creates required parent directories and symlinks.

---

## Usage

### Initial setup

```bash
cd ~/.dotfiles
```

### Stow packages

```bash
stow zsh tmux ghostty git starship ideavim
```

You can stow individual packages as needed.

### Remove symlinks (unstow)

```bash
stow -D tmux
```

This removes symlinks from `$HOME` **without deleting files** inside `.dotfiles`.

---

## Workflow

1. Edit files **inside `.dotfiles`**
2. Symlinks update automatically
3. Reload or restart the relevant application
4. Commit changes to git

⚠️ **Never edit the symlinked files in `$HOME` directly.**

---

## Git Configuration

### Version-controlled

* `git/.gitconfig`

  * Global Git settings
  * User identity
  * Includes for local overrides

### NOT version-controlled (by design)

* `~/.gitconfig.local`
* `~/.git-credentials`
* SSH keys or tokens

These are **machine-specific and security-sensitive**.

`.gitconfig` includes `.gitconfig.local` if it exists.
Git works normally even if `.gitconfig.local` is missing.

### New machine setup (Git)

1. Clone this repository
2. Run `stow git`
3. Authenticate once (SSH key or HTTPS token)

Credentials are regenerated per machine.

---

## Tmux Integration

Tmux configuration includes:

* **Custom prefix** (`Ctrl+a`)
* Vi-style navigation and copy mode
* System clipboard integration
* Popup-based workflows:

  * **Lazygit** (Git TUI)
  * **Shell popups**
  * **Dotfiles editor menu**

All popup entries point directly to files inside `~/.dotfiles`, which is the source of truth.

> Lazygit must be installed separately.

---

## Shell (Zsh)

Zsh configuration includes:

* **Starship prompt**
* **Zoxide** (replaces `cd` with frecency-based navigation)
* Aliases and PATH management
* Integration with tools such as:

  * `fd`
  * `rg`
  * `lazygit`
  * `yazi` (if installed)

Some features depend on optional tools being present.

---

## System Assumptions

This setup assumes:

### Required

* Linux
* GNU Stow
* Zsh
* Git
* Tmux

### Optional (recommended)

* Ghostty (terminal emulator)
* Starship
* Lazygit
* Zoxide
* fd
* ripgrep
* Neovim (for editing via tmux popups)

Missing optional tools do **not** break the setup; related features simply remain inactive.

---

## Safety Notes

* Always `cd ~/.dotfiles` before running `stow`
* Avoid filename conflicts between packages
* Use `stow -n <package>` for dry runs
* Keep backups temporarily when migrating configs

---

## Purpose

This repository exists for:

* Personal system reproducibility
* Learning and understanding Linux configuration
* Clean separation of concerns
* Long-term maintainability

This is **not a generic dotfiles repository** and is not intended for public reuse.


