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

export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

export EDITOR="nvim"
export FD="fd"

export PATH="$PATH:$GOPATH/bin:$CARGO_HOME/bin"
