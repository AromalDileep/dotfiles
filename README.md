
# Dotfiles

This repository contains my **personal, declarative system configuration**, designed for:

- Long-term maintainability
- Cross-machine reproducibility
- Deep understanding of Linux configuration
- Clean separation of concerns

This is **not** a generic dotfiles repository and is **not intended for public reuse**.

---

## Tmux Integration

The Tmux configuration is designed as a **central control layer** for development workflows.

### Features

- Custom prefix: `Ctrl+a`
- Vi-style navigation and copy mode
- System clipboard integration
- Popup-based workflows, including:
  - Lazygit (Git TUI)
  - Shell popups
  - Dotfiles editor menu

All popup entries reference files directly inside `~/.dotfiles`, which is treated as the **single source of truth**.  
No generated state or transient files are edited through these menus.

> **Note**: `lazygit` must be installed separately for Git popups to work.

---

## Shell (Zsh)

The Zsh configuration provides a **minimal but powerful interactive shell**, optimized for terminal-first workflows.

### Features

- Starship prompt
- Zoxide (frecency-based directory navigation, replacing traditional `cd`)
- Aliases and PATH management
- Integration with commonly used CLI tools:
  - `fd`
  - `ripgrep (rg)`
  - `lazygit`
  - `yazi` (if installed)

All integrations are **optional**.  
If a tool is not installed, related aliases or features remain inactive **without causing errors**.

---

## Neovim (AstroNvim)

Neovim is managed using **AstroNvim**, with configuration stored and versioned via GNU Stow.

### Key characteristics

- AstroNvim template-based configuration
- Plugin management via `lazy.nvim`
- Explicit plugin specs under `lua/plugins/`
- `flash.nvim` installed and configured for fast navigation
- Treesitter, LSP, formatting, and UI configuration split cleanly by concern
- `lazy-lock.json` tracked for reproducibility

### What is tracked

Only the following directory is stowed and tracked:

```

~/.config/nvim

```

### What is explicitly excluded

```

~/.local/share/nvim
~/.local/state/nvim
~/.cache/nvim

```

This ensures:
- Safe upgrades
- No machine-specific state in Git
- Clean restores on new systems

---

## Terminal Emulator (Ghostty)

The primary terminal emulator is **Ghostty**.

### Reasons for choosing Ghostty

- Correct input handling for terminal applications (notably Neovim)
- Wayland-friendly
- Simple, explicit configuration
- No known key duplication issues

### Configuration

Ghostty is configured via:

```

~/.config/ghostty/config

```

The configuration includes:
- Catppuccin theme
- Font and padding settings
- Minimal, predictable behavior

Ghostty is installed via a **community-maintained Ubuntu package**.  
Updates are performed by re-running the installer script.

---

## Git Configuration (Canonical Setup)

Git is treated as **declarative configuration**, fully managed via dotfiles and **SSH-only authentication**.

### Design principles

- No HTTPS authentication
- No credential helpers
- No machine-local includes
- No hidden state
- SSH is handled entirely via `~/.ssh`, not Git config

This ensures:
- Reproducibility across machines
- Clean security boundaries
- Zero password or token prompts
- Compatibility with tmux popups and `lazygit`

### Tracked Git config

The following file is stowed:

```

~/.gitconfig → ~/.dotfiles/git/.gitconfig

````

Contents:

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

### Important note on previous Git setup

Older setups used:

* HTTPS authentication
* `credential.helper=store`
* `~/.gitconfig.local` includes

These have been **intentionally removed**.

They are:

* Not reproducible
* Machine-specific
* Incompatible with SSH-only workflows

This repository **does not support** that model anymore.

---

## Git Setup on a New Machine

Follow these steps **in order**.

### 1. Install Git and SSH

```bash
sudo apt install git openssh-client   # Ubuntu
sudo dnf install git openssh-clients  # Fedora
```

---

### 2. Generate an SSH key

```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

Add the public key to GitHub:

```bash
cat ~/.ssh/id_ed25519.pub
```

Verify:

```bash
ssh -T git@github.com
```

---

### 3. Clone dotfiles

```bash
git clone git@github.com:AromalDileep/dotfiles.git ~/.dotfiles
```

---

### 4. Apply Git config

If a Git config already exists:

```bash
mv ~/.gitconfig ~/.gitconfig.bak
mv ~/.gitconfig.local ~/.gitconfig.local.bak  # if present
```

Then stow Git:

```bash
cd ~/.dotfiles
stow git
```

Verify:

```bash
git config --list --show-origin
```

You should see **only** entries from `~/.gitconfig` and no credential helpers.

---

## GNU Stow Usage

GNU Stow is used to manage **only declarative configuration**, never generated state.

### Stowed packages

* `nvim`
* `ghostty`
* `zsh`
* `tmux`
* `starship`
* `git`
* `ideavim`

### Rules

* Always `cd ~/.dotfiles` before running stow
* Use `stow -n <package>` for dry runs
* Avoid filename collisions across packages
* Do not stow cache, state, or runtime directories

---

## System Assumptions

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
* `fd`
* `ripgrep`
* Neovim

Missing optional tools do **not** break the system.
Related features simply remain inactive.

---

## Safety Notes

* Always verify changes before committing
* Keep temporary backups when migrating configurations
* Avoid tracking machine-specific or auto-generated files
* Prefer explicit configuration over implicit defaults

---

## Purpose

This repository exists to support:

* Personal system reproducibility
* Learning and understanding Linux configuration deeply
* Clean separation of concerns
* Long-term maintainability and stability


