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
