# Dotfiles

Personal dotfiles managed using GNU Stow.

## Structure

Each directory represents a Stow package and mirrors the directory structure
relative to `$HOME`.

Example:
- `zsh/.zshrc` → `~/.zshrc`
- `kitty/.config/kitty/kitty.conf` → `~/.config/kitty/kitty.conf`

## Usage

To symlink all configurations:

```bash
cd ~/.dotfiles
stow zsh kitty


#To remove symlinks:
cd ~/.dotfiles
stow -D zsh kitty
