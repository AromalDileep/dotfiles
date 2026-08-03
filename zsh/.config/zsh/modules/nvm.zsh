# nvm (Node Version Manager - Lazy Loaded)
export NVM_DIR="$HOME/.nvm"
_lazy_load_nvm() {
  unset -f nvm node npm npx yarn pnpm _lazy_load_nvm
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  fi
}
nvm() { _lazy_load_nvm; nvm "$@"; }
node() { _lazy_load_nvm; node "$@"; }
npm() { _lazy_load_nvm; npm "$@"; }
npx() { _lazy_load_nvm; npx "$@"; }
yarn() { _lazy_load_nvm; yarn "$@"; }
pnpm() { _lazy_load_nvm; pnpm "$@"; }
