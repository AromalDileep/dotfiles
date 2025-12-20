
# Dotfiles

This repository contains my **personal, declarative system configuration**, designed for:

- Long-term maintainability
- Cross-machine reproducibility
- Deep understanding of Linux configuration
- Clean separation of concerns

This is **not** a generic dotfiles repository and is **not intended for public reuse**.

---

## Tmux

Tmux acts as the **central control layer** for terminal-based workflows.

### Features

- Prefix: `Ctrl+a`
- Vi-style navigation and copy mode
- System clipboard integration
- Popup workflows:
  - Lazygit (Git TUI)
  - Shell popups
  - Dotfiles editor menu

All popups reference files directly inside `~/.dotfiles`, which is treated as the **single source of truth**.  
No generated or transient state is edited via tmux.

> **Note**: `lazygit` must be installed separately for Git popups.

---

## Shell (Zsh)

Zsh provides a **minimal, terminal-first shell environment**.

### Included

- Starship prompt
- Zoxide (frecency-based directory navigation)
- Aliases and PATH management
- Optional integrations:
  - `fd`
  - `ripgrep (rg)`
  - `lazygit`
  - `yazi`

If a tool is not installed, related integrations remain inactive **without errors**.

---

## Neovim (AstroNvim)

Neovim is managed via **AstroNvim**, with configuration stored declaratively using GNU Stow.

### Characteristics

- AstroNvim template-based setup
- Plugin management via `lazy.nvim`
- Explicit plugin specs under `lua/plugins/`
- `flash.nvim` for fast navigation
- Clean separation of LSP, UI, formatting, and Treesitter
- `lazy-lock.json` tracked for reproducibility

### Tracked

```

~/.config/nvim

```

### Explicitly excluded

```

~/.local/share/nvim
~/.local/state/nvim
~/.cache/nvim

```

This guarantees:
- Safe upgrades
- No machine-specific state in Git
- Clean restores on new systems

---

## Terminal Emulators

### Ghostty (Primary)

Ghostty is the primary terminal emulator.

**Why Ghostty**
- Correct input handling (notably Neovim)
- Wayland-friendly
- Simple, predictable behavior
- No known key duplication issues

**Config**
```

~/.config/ghostty/config

```

Installed via a community-maintained Ubuntu package.  
Updates are done by re-running the installer.

---

### Kitty (Optional)

Kitty is supported as an **alternative terminal emulator**.

**Design**
- Configuration is fully managed via dotfiles
- Safe to stow even if Kitty is not installed
- No runtime impact unless Kitty is launched

**Config**
```

~/.config/kitty

```

Kitty is optional and does not affect:
- tmux
- Zsh
- Git
- Ghostty
- Neovim

---

## Git (Canonical Setup)

Git is managed **declaratively** and uses **SSH-only authentication**.

### Principles

- No HTTPS authentication
- No credential helpers
- No machine-local includes
- No hidden state
- SSH handled exclusively via `~/.ssh`

This ensures:
- Reproducibility
- Clean security boundaries
- Compatibility with tmux and `lazygit`

### Tracked config

```

~/.gitconfig → ~/.dotfiles/git/.gitconfig

````

```ini
[user]
    name = Aromal Dileep
    email = aromaldileep96@gmail.com

[init]
    defaultBranch = main

[core]
    editor = nvim

[pull]
    rebase = false

[fetch]
    prune = true

[color]
    ui = auto
````

### Legacy Git setup (removed)

Previous setups using:

* HTTPS authentication
* `credential.helper=store`
* `~/.gitconfig.local`

are **intentionally unsupported**.

---

## Git Setup on a New Machine

1. Install Git + SSH

```bash
sudo apt install git openssh-client   # Ubuntu
sudo dnf install git openssh-clients  # Fedora
```

2. Generate SSH key

```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

3. Add key to GitHub and verify

```bash
ssh -T git@github.com
```

4. Clone dotfiles

```bash
git clone git@github.com:AromalDileep/dotfiles.git ~/.dotfiles
```

5. Apply Git config

```bash
mv ~/.gitconfig ~/.gitconfig.bak
mv ~/.gitconfig.local ~/.gitconfig.local.bak  # if present
cd ~/.dotfiles
stow git
```

Verify:

```bash
git config --list --show-origin
```

---

## GNU Stow

Stow is used for **declarative configuration only**.

### Managed packages

* `nvim`
* `ghostty`
* `kitty`
* `zsh`
* `tmux`
* `starship`
* `git`
* `ideavim`

### Rules

* Always `cd ~/.dotfiles` before stowing
* Use `stow -n <package>` for dry runs
* Never stow cache, runtime, or generated state

---

## System Assumptions

### Required

* Linux
* GNU Stow
* Zsh
* Git
* Tmux

### Optional

* Ghostty
* Kitty
* Starship
* Lazygit
* Zoxide
* `fd`
* `ripgrep`
* Neovim

Missing optional tools do **not** break the system.

---

## Safety Notes

* Verify changes before committing
* Keep temporary backups during migrations
* Avoid tracking machine-specific artifacts
* Prefer explicit configuration over implicit defaults

---

## Purpose

This repository exists to support:

* Personal system reproducibility
* Deep understanding of Linux configuration
* Clean separation of concerns
* Long-term stability and maintainability
ist**
* Add a **design rationale section**
* Help you decide **Kitty vs Ghostty long-term**
* Add a **quick audit checklist** for future changes
