
## Tmux Integration

The Tmux configuration is designed as a **central control layer** for development workflows.

It includes:

* **Custom prefix**: `Ctrl+a`
* **Vi-style navigation** and copy mode
* **System clipboard integration**
* **Popup-based workflows**, including:

  * **Lazygit** (Git TUI)
  * **Shell popups**
  * **Dotfiles editor menu**

All popup entries reference files **directly inside `~/.dotfiles`**, which is treated as the **single source of truth**.
No generated state or transient files are edited through these menus.

> **Note:** `lazygit` must be installed separately for Git popups to work.

---

## Shell (Zsh)

The Zsh configuration provides a **minimal but powerful interactive shell environment**, optimized for terminal-first workflows.

It includes:

* **Starship prompt**
* **Zoxide** (frecency-based directory navigation, replacing traditional `cd`)
* Aliases and PATH management
* Integration with commonly used CLI tools, including:

  * `fd`
  * `ripgrep (rg)`
  * `lazygit`
  * `yazi` (if installed)

All integrations are **optional**.
If a tool is not installed, related aliases or features remain inactive without causing errors.

---

## Neovim (AstroNvim)

Neovim is managed using **AstroNvim**, with configuration stored and versioned via GNU Stow.

Key characteristics:

* AstroNvim template-based configuration
* Plugin management via `lazy.nvim`
* Explicit plugin specs under `lua/plugins/`
* **flash.nvim** installed and configured for fast navigation
* Treesitter, LSP, formatting, and UI configuration split cleanly by concern
* `lazy-lock.json` tracked for reproducibility

Only the following directory is stowed and tracked:

```text
~/.config/nvim
```

All Neovim runtime and cache directories are **explicitly excluded**:

```text
~/.local/share/nvim
~/.local/state/nvim
~/.cache/nvim
```

This ensures:

* Safe upgrades
* No machine-specific state in Git
* Clean restores on new systems

---

## Terminal Emulator

The primary terminal emulator is **Ghostty**.

Reasons for choosing Ghostty:

* Correct input handling for terminal applications (notably Neovim)
* Wayland-friendly
* Simple, explicit configuration
* No known key duplication issues

Ghostty is configured via:

```text
~/.config/ghostty/config
```

The configuration includes:

* Catppuccin theme
* Font and padding settings
* Minimal, predictable behavior

> Ghostty is installed via a community-maintained Ubuntu package. Updates are performed by re-running the installer script.

---

## GNU Stow Usage

GNU Stow is used to manage **only declarative configuration**, never generated state.

### Stowed packages include:

* `nvim`
* `ghostty`
* `zsh`
* `tmux`
* `starship`
* `git`
* `ideavim`

### General rules:

* Always `cd ~/.dotfiles` before running `stow`
* Avoid filename collisions across packages
* Use `stow -n <package>` for dry runs
* Do **not** stow cache, state, or runtime directories

---

## System Assumptions

This setup assumes the following are present:

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
* Neovim (used directly and via tmux popups)

Missing optional tools **do not break the system**; related features simply remain inactive.

---

## Safety Notes

* Always verify changes before committing
* Keep temporary backups when migrating configurations
* Avoid tracking machine-specific or auto-generated files
* Prefer explicit configuration over implicit defaults

---

## Purpose

This repository exists to support:

* **Personal system reproducibility**
* Learning and understanding Linux configuration deeply
* Clean separation of concerns
* Long-term maintainability and stability

This is **not a generic dotfiles repository** and is **not intended for public reuse**.
