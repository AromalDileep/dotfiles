

# Dotfiles

This repository contains my personal dotfiles, managed using **GNU Stow**.
The goal is to keep all configuration files **version-controlled, modular, and reproducible** across systems while keeping `$HOME` clean.

This is a **private repository**, intended for my own learning, reference, and long-term maintainability.

---

## Why GNU Stow

GNU Stow is used to manage dotfiles via **symbolic links** instead of copying files directly into `$HOME`.

### Advantages

* Single source of truth for all configuration
* Modular management (add/remove whole config groups)
* Clean `$HOME` (no duplicated config files)
* Safe to version control
* Fully reversible

Stow **never edits files** — it only creates or removes symlinks.

---

## Repository Layout

Each **top-level directory** is a *Stow package*.
A package mirrors the directory structure **relative to `$HOME`**.

Example:

```
.dotfiles/
├── ideavim
│   └── .ideavimrc
├── git
│   └── .gitconfig
├── kitty
│   └── .config
│       └── kitty
│           └── kitty.conf
├── starship
│   └── .config
│       └── starship.toml
├── tmux
│   └── .tmux.conf
├── zsh
│   └── .zshrc
└── README.md
```

Mapping examples:

* `zsh/.zshrc`
  → `$HOME/.zshrc`
* `kitty/.config/kitty/kitty.conf`
  → `$HOME/.config/kitty/kitty.conf`

Stow automatically creates required parent directories and symlinks.

---

## How Stow Works (Important)

When running:

```bash
stow kitty
```

Stow:

1. Reads the `kitty/` directory
2. Interprets paths **relative to `$HOME`**
3. Creates symlinks in `$HOME`
4. Points those symlinks back to this repository

Example:

```
~/.config/kitty/kitty.conf -> ~/.dotfiles/kitty/.config/kitty/kitty.conf
```

The **real files live inside `.dotfiles`**.
`$HOME` only contains symlinks.

---

## Usage

### Initial setup

```bash
cd ~/.dotfiles
```

### Stow specific packages

```bash
stow zsh
stow kitty
```

Multiple packages at once:

```bash
stow zsh kitty tmux
```

---

### Remove symlinks (unstow)

```bash
stow -D zsh
stow -D kitty
```

This:

* Removes symlinks from `$HOME`
* Does **not** delete files inside `.dotfiles`

---

## Typical Workflow

1. Edit files **inside `.dotfiles`**
2. Symlinks update automatically
3. Reload or restart the relevant application
4. Commit changes to Git

Never edit symlinked files in `$HOME` directly — always edit the real files
inside `.dotfiles`.

---

## Git Configuration (Important)

Git configuration is managed explicitly and securely.

### What is version-controlled

The following is stowed and committed:

```
git/.gitconfig
```

It contains:

* User identity (`name`, `email`)
* Default Git behavior (e.g. default branch)
* An include directive for local overrides

Example:

```ini
[init]
    defaultBranch = main

[user]
    name = Aromal Dileep
    email = aromaldileep96@gmail.com

[include]
    path = ~/.gitconfig.local
```

---

### What is NOT version-controlled

The following are intentionally **not** stowed or committed:

* `~/.gitconfig.local`
* `~/.git-credentials`
* SSH keys or tokens

These files are **machine-specific and security-sensitive**.

`~/.gitconfig.local` is used for:

* Credential helpers
* Machine-specific Git settings
* Optional signing keys

Git will continue to work even if `.gitconfig.local` does not exist.

---

### New machine setup (Git)

On a new machine:

1. Clone this repository
2. Run `stow git`
3. Authenticate once (SSH key or HTTPS token)

No manual Git reconfiguration is required.
Credentials are handled locally and regenerated per machine.

---

## Kitty Configuration Notes

Kitty configuration is modular.

Typical layout:

```
kitty/
└── .config/kitty/
    ├── kitty.conf        # entry point
    ├── theme.conf        # active theme include
    ├── keybindings.conf
    └── themes/
```

`kitty.conf` includes other files using:

```conf
include theme.conf
include keybindings.conf
```

Themes are switched by editing `theme.conf`, not `kitty.conf`.

---

## Safety Notes

* Always `cd ~/.dotfiles` before running `stow`
* Avoid filename conflicts between packages
* Use `stow -n <package>` for dry runs
* Keep backups temporarily when migrating files

---

## System Assumptions

This setup assumes:

* Linux
* `$HOME`-based configuration
* GNU Stow installed
* Zsh as shell
* Kitty as terminal emulator

---

## Purpose of This Repository

* Personal system reproducibility
* Learning and understanding Linux configuration
* Clean separation of concerns
* Long-term maintainability

This repository is **not intended to be generic or public-facing**.
It is optimized specifically for my workflow and preferences.

