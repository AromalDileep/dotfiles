# ---------------------------------------
# ZSH HISTORY (Persistent across sessions)
# ---------------------------------------
HISTFILE=$HOME/.zsh_history
HISTSIZE=500000
SAVEHIST=500000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ------------------------
# Starship Prompt Init
# ------------------------
eval "$(starship init zsh)"

# ------------------------
# Zsh Plugins
# ------------------------
# Disable autosuggestions
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (must be before bindkeys)
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --------------------------------------------------
# Prefix-Based History Search (Up/Down Keys)
# Must come AFTER plugins
# --------------------------------------------------
bindkey "^[[A" history-beginning-search-backward   # Up arrow
bindkey "^[OA" history-beginning-search-backward   # Alt Up compatibility

bindkey "^[[B" history-beginning-search-forward    # Down arrow
bindkey "^[OB" history-beginning-search-forward    # Alt Down compatibility

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"


# ------------------------------------------
# Conda Initialization (automatically managed)
# ------------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/aromal/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/aromal/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/aromal/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/aromal/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh

# yazi wrapper: sync shell cwd with yazi on exit
y() {
  local tmp
  tmp="$(mktemp)" || return
  yazi --cwd-file="$tmp"
  if [ -s "$tmp" ]; then
    local cwd
    cwd="$(cat "$tmp")"
    [ -d "$cwd" ] && cd "$cwd"
  fi
  rm -f "$tmp"
}

# Zoxide initialization:
# - Enables frecency-based directory jumping
# - Overrides `cd` instead of introducing `z`
eval "$(zoxide init --cmd cd zsh)"
