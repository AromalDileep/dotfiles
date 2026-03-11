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

# ---------------------------------------
# LS colors (file / directory distinction)
# ---------------------------------------
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors)"
fi

alias ls='ls --color=auto'

# ------------------------
# Starship Prompt Init
# ------------------------
eval "$(starship init zsh)"

# ------------------------
# Zsh Plugins
# ------------------------
# Disable autosuggestions
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Vi mode everywhere
bindkey -v 

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


# ------------------------------------------
# Auto-update tmux environment on env or conda activate/deactivate
# ------------------------------------------
if [ -n "$TMUX" ]; then
  _tmux_env_hook() {
    tmux set-environment CONDA_DEFAULT_ENV "${CONDA_DEFAULT_ENV:-}"
    tmux set-environment VIRTUAL_ENV "${VIRTUAL_ENV:-}"
  }
  
  precmd_functions+=(_tmux_env_hook)
fi


[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh

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

# Created by `pipx` on 2025-12-18 05:34:32 (Kitty priority)
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

export PATH="$HOME/.cargo/bin:$PATH"

# Reduce TensorFlow C++ startup logs (hide INFO/WARNING; show only errors)
export TF_CPP_MIN_LOG_LEVEL=2

# Disable bat pager so output prints directly like cat (no less/paging)
export BAT_PAGER=cat

# Add OpenCode CLI (installed in ~/.opencode/bin) to PATH
export PATH="$HOME/.opencode/bin:$PATH"

# Zsh syntax highlighting (cross-distro)
for _zsh_sh in \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  if [[ -f "$_zsh_sh" ]]; then
    source "$_zsh_sh"
    break
  fi
done
unset _zsh_sh

figlet -f smslant "System Ready" | lolcat
