# Command-completion notification policy.
# Set ZSH_COMMAND_NOTIFY=off before starting an interactive shell to opt that
# shell (for example, a designated Herdr agent pane) out of notifications.

# Minimum foreground command duration, in seconds, before notifying.
typeset -g ZSH_COMMAND_NOTIFY_THRESHOLD_SECONDS=10

# Whether successful commands produce desktop notifications.
typeset -g ZSH_COMMAND_NOTIFY_SUCCESS=true
# Whether failed commands produce desktop notifications.
typeset -g ZSH_COMMAND_NOTIFY_FAILURE=true

# Whether completion sounds are enabled.
typeset -g ZSH_COMMAND_NOTIFY_SOUND_ENABLED=false
# Whether sounds are restricted to failed commands when sound is enabled.
typeset -g ZSH_COMMAND_NOTIFY_SOUND_ONLY_FAILURE=true

# Expiry for successful-command notifications in milliseconds.
# The notification daemon may apply its own expiry policy instead.
typeset -g ZSH_COMMAND_NOTIFY_SUCCESS_TIMEOUT_MS=6000
# Expiry for failed-command notifications in milliseconds.
typeset -g ZSH_COMMAND_NOTIFY_FAILURE_TIMEOUT_MS=12000

# FreeDesktop urgency hint for successful commands.
typeset -g ZSH_COMMAND_NOTIFY_SUCCESS_URGENCY=low
# FreeDesktop urgency hint for failed commands.
typeset -g ZSH_COMMAND_NOTIFY_FAILURE_URGENCY=normal

# Commands that are normally interactive and should not notify when they exit.
# Add command names here rather than changing the implementation module.
typeset -ga ZSH_COMMAND_NOTIFY_EXCLUDED_COMMANDS=(
  btop fzf htop lazygit less lf man more most mosh nnn nvim ranger ssh tig
  top vi view vim watch yazi zsh bash sh fish nu
)

# Environment variable used to opt an entire shell out of notifications.
typeset -g ZSH_COMMAND_NOTIFY_OPT_OUT_ENV=ZSH_COMMAND_NOTIFY
# Value of the opt-out environment variable that disables notifications.
# A pane launched with ZSH_COMMAND_NOTIFY=off keeps normal Herdr panes enabled
# while suppressing command alerts in explicitly designated AI-agent panes.
typeset -g ZSH_COMMAND_NOTIFY_OPT_OUT_VALUE=off

# Set to "recent" to replace a recent notification from the same shell.
# "off" keeps individual notifications visible.
typeset -g ZSH_COMMAND_NOTIFY_REPLACE_MODE=off
# Replacement window, in seconds, when replacement mode is "recent".
typeset -g ZSH_COMMAND_NOTIFY_REPLACE_WINDOW_SECONDS=4

# Maximum displayed command-summary length, in characters.
typeset -g ZSH_COMMAND_NOTIFY_MAX_COMMAND_LENGTH=160
