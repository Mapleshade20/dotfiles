export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export YADM_ROOT="$HOME"
export RUFF_CACHE_DIR="$XDG_CACHE_HOME/ruff"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export _JAVA_OPTIONS=-Djavafx.cachedir="$XDG_CACHE_HOME/openjfx"
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"

export DENO_INSTALL_ROOT="$XDG_DATA_HOME/deno/bin"
export BUN_INSTALL="$XDG_DATA_HOME/bun" 
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

export ZSH="$ZDOTDIR/oh-my-zsh"
export EDITOR="nvim"
export FD="fd"

typeset -U path PATH
local extra_paths=(
    "$GOPATH/bin"
    "$CARGO_HOME/bin"
    "$HOME/.local/bin"
    "$XDG_DATA_HOME/npm/bin"
    "$DENO_INSTALL_ROOT"
    "$BUN_INSTALL/bin"
    "/opt/homebrew/opt/make/libexec/gnubin"
    "/opt/homebrew/opt/postgresql@18/bin"
)
for p in $extra_paths; do
    [[ -d "$p" ]] && path=("$p" $path)
done

export PATH
