

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
## Tooling Expectations

This repository configures user-level tools but **does not install them**.
The following tools are expected to be present for the configuration to be
fully effective.

If a tool is not installed, the system will continue to function, but
related enhancements or integrations will be inactive.

### Core tools (expected)

These tools are directly configured by this repository:

- **zsh**  
  Primary shell. All shell behavior and integrations are defined in `.zshrc`.

- **git**  
  Global Git behavior is configured via `.gitconfig`.  
  Authentication and credentials are intentionally handled outside this repo.

- **tmux**  
  Terminal multiplexer configured via `.tmux.conf`.

- **kitty**  
  Terminal emulator. Configuration is applied only if Kitty is used.

- **starship**  
  Cross-shell prompt. The prompt configuration assumes Starship is installed
  and enabled from the shell.

- **IdeaVim**  
  Vim emulation inside JetBrains IDEs, configured via `.ideavimrc`.

### Integrated CLI tools (optional but recommended)

These tools are referenced or integrated within shell configuration:

- **zoxide**  
  Enhances directory navigation by replacing the default `cd` command with
  a frecency-based implementation while preserving `cd` usage.

- **fd**  
  Modern replacement for `find`.  
  On Ubuntu/Debian, the binary may be provided as `fdfind` and exposed as `fd`
  by the distribution. On Arch and macOS, the binary is `fd`.

- **ripgrep (`rg`)**  
  Fast recursive search utility commonly used in CLI and editor workflows.

- **yazi**  
  Terminal file manager.  
  Shell integration logic exists in `.zshrc` to ensure that when Yazi exits,
  the shell automatically switches to the last directory visited inside Yazi.
  No Yazi configuration is stowed unless explicitly added.

All tools are expected to be installed using the system package manager
(e.g. `apt`, `pacman`, `brew`) and are intentionally **not managed by this
repository**.

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

