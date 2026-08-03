# Foreground interactive-command completion notifications for Zsh.

[[ -o interactive ]] || return 0

autoload -Uz add-zsh-hook
zmodload zsh/datetime 2>/dev/null || true

typeset -g __zsh_command_notify_command=''
typeset -g __zsh_command_notify_started_at=''
typeset -g __zsh_command_notify_notification_id=''
typeset -g __zsh_command_notify_notification_sent_at=''

# Interpret the small boolean vocabulary used by the policy file.
_zsh_command_notify_enabled() {
  [[ $1 == (1|true|yes|on) ]]
}

# Return whether this shell was explicitly opted out by its environment.
_zsh_command_notify_opted_out() {
  local value="${(P)ZSH_COMMAND_NOTIFY_OPT_OUT_ENV}"
  [[ $value == "$ZSH_COMMAND_NOTIFY_OPT_OUT_VALUE" ]]
}

# Use a high-resolution clock when zsh/datetime is available, with SECONDS as
# a portable Zsh fallback.
_zsh_command_notify_now() {
  if (( ${+EPOCHREALTIME} )); then
    print -r -- "$EPOCHREALTIME"
  else
    print -r -- "$SECONDS"
  fi
}

# Extract the executable name without evaluating the command line. This is
# deliberately conservative; unfamiliar compound syntax falls back to its
# first meaningful token.
_zsh_command_notify_executable() {
  local command_line=$1 token wrapper='' skip_wrapper_argument=false
  local -a words
  words=( ${(z)command_line} )

  for token in "${words[@]}"; do
    if [[ $skip_wrapper_argument == true ]]; then
      skip_wrapper_argument=false
      continue
    fi
    [[ $token =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]] && continue

    case $token in
      command|builtin|exec|noglob|nocorrect|time)
        continue
        ;;
      env)
        wrapper=env
        continue
        ;;
      sudo|doas)
        wrapper=sudo
        continue
        ;;
      -*)
        if [[ $wrapper == sudo && $token == (-u|-g|-h|-p|-r|-t|-C|-c) ]]; then
          skip_wrapper_argument=true
        fi
        continue
        ;;
      *)
        [[ $wrapper == sudo ]] && wrapper=''
        print -r -- "${token:t}"
        return 0
        ;;
    esac
  done
}

# Avoid alerts for configured interactive programs.
_zsh_command_notify_excluded() {
  local executable=$1 excluded
  for excluded in "${ZSH_COMMAND_NOTIFY_EXCLUDED_COMMANDS[@]}"; do
    [[ $executable == "$excluded" ]] && return 0
  done
  return 1
}

# A trailing background operator means the shell did not wait for completion.
_zsh_command_notify_background() {
  local command_line=$1
  local -a words
  words=( ${(z)command_line} )
  (( ${#words} > 0 )) || return 1
  [[ ${words[-1]} == '&' || ${words[-1]} == '&!' ]]
}

# Remove common control characters, collapse whitespace, and cap notification
# content without evaluating any user-supplied command text.
_zsh_command_notify_summary() {
  local summary=$1
  local max_length=$ZSH_COMMAND_NOTIFY_MAX_COMMAND_LENGTH

  summary=${summary//$'\n'/ }
  summary=${summary//$'\r'/ }
  summary=${summary//$'\t'/ }
  summary=${summary//$'\e'/}
  summary=${summary//$'\a'/}
  while [[ $summary == *'  '* ]]; do
    summary=${summary//  / }
  done
  summary=${summary## ##}
  summary=${summary%% ##}

  if (( ${#summary} > max_length )); then
    summary="${summary[1,max_length - 1]}…"
  fi
  print -r -- "$summary"
}

_zsh_command_notify_duration() {
  local elapsed=$1
  printf '%.1f s' "$elapsed"
}

# Send a compact FreeDesktop notification. Replacement mode intentionally uses
# the synchronous ID-returning path; the default mode stays asynchronous.
_zsh_command_notify_desktop() {
  local title=$1 body=$2 urgency=$3 timeout=$4 now=$5
  local -a arguments
  arguments=(--app-name='Zsh command' --urgency="$urgency" --expire-time="$timeout")

  if [[ $title == 'Command failed' ]]; then
    arguments+=(--icon=dialog-error)
  else
    arguments+=(--icon=utilities-terminal)
  fi

  if [[ $ZSH_COMMAND_NOTIFY_REPLACE_MODE == recent ]] \
    && [[ -n $__zsh_command_notify_notification_id ]] \
    && (( now - __zsh_command_notify_notification_sent_at <= ZSH_COMMAND_NOTIFY_REPLACE_WINDOW_SECONDS )); then
    local notification_id
    notification_id=$(command notify-send --print-id --replace-id="$__zsh_command_notify_notification_id" "${arguments[@]}" "$title" "$body" 2>/dev/null) || return 0
    [[ -n $notification_id ]] && __zsh_command_notify_notification_id=$notification_id
    __zsh_command_notify_notification_sent_at=$now
    return 0
  fi

  if [[ $ZSH_COMMAND_NOTIFY_REPLACE_MODE == recent ]]; then
    local notification_id
    notification_id=$(command notify-send --print-id "${arguments[@]}" "$title" "$body" 2>/dev/null) || return 0
    [[ -n $notification_id ]] && __zsh_command_notify_notification_id=$notification_id
    __zsh_command_notify_notification_sent_at=$now
  else
    command notify-send "${arguments[@]}" "$title" "$body" >/dev/null 2>&1 &!
  fi
}

# Play a themed desktop event without holding up prompt rendering.
_zsh_command_notify_sound() {
  local failed=$1 event
  _zsh_command_notify_enabled "$ZSH_COMMAND_NOTIFY_SOUND_ENABLED" || return 0
  if _zsh_command_notify_enabled "$ZSH_COMMAND_NOTIFY_SOUND_ONLY_FAILURE" && (( ! failed )); then
    return 0
  fi
  command -v canberra-gtk-play >/dev/null 2>&1 || return 0

  if (( failed )); then
    event=dialog-error
  else
    event=complete
  fi
  command canberra-gtk-play --id="$event" --description='Zsh command completion' >/dev/null 2>&1 &!
}

# Record only foreground commands that are candidates for notification.
_zsh_command_notify_preexec() {
  local command_line=$1 executable
  __zsh_command_notify_command=''
  __zsh_command_notify_started_at=''

  _zsh_command_notify_opted_out && return 0
  _zsh_command_notify_background "$command_line" && return 0
  executable=$(_zsh_command_notify_executable "$command_line")
  _zsh_command_notify_excluded "$executable" && return 0

  __zsh_command_notify_command=$command_line
  __zsh_command_notify_started_at=$(_zsh_command_notify_now)
}

# Notify after a command returns to the prompt while preserving its exit code.
_zsh_command_notify_precmd() {
  local exit_status=$? command_line=$__zsh_command_notify_command
  local started_at=$__zsh_command_notify_started_at now elapsed failed title body
  local enabled urgency timeout summary

  __zsh_command_notify_command=''
  __zsh_command_notify_started_at=''
  [[ -n $command_line && -n $started_at ]] || return $exit_status
  _zsh_command_notify_opted_out && return $exit_status

  now=$(_zsh_command_notify_now)
  (( elapsed = now - started_at ))
  (( elapsed >= ZSH_COMMAND_NOTIFY_THRESHOLD_SECONDS )) || return $exit_status

  if (( exit_status == 0 )); then
    enabled=$ZSH_COMMAND_NOTIFY_SUCCESS
    urgency=$ZSH_COMMAND_NOTIFY_SUCCESS_URGENCY
    timeout=$ZSH_COMMAND_NOTIFY_SUCCESS_TIMEOUT_MS
    title='Command completed'
    failed=0
  else
    enabled=$ZSH_COMMAND_NOTIFY_FAILURE
    urgency=$ZSH_COMMAND_NOTIFY_FAILURE_URGENCY
    timeout=$ZSH_COMMAND_NOTIFY_FAILURE_TIMEOUT_MS
    title='Command failed'
    failed=1
  fi
  _zsh_command_notify_enabled "$enabled" || return $exit_status

  summary=$(_zsh_command_notify_summary "$command_line")
  body="$summary — $(_zsh_command_notify_duration "$elapsed")"
  (( failed )) && body+=" · Exit $exit_status"
  _zsh_command_notify_desktop "$title" "$body" "$urgency" "$timeout" "$now"
  _zsh_command_notify_sound "$failed"
  return $exit_status
}

add-zsh-hook preexec _zsh_command_notify_preexec
add-zsh-hook precmd _zsh_command_notify_precmd
