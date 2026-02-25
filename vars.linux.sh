export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

export EDITOR=hx
# export EDITOR=nvim
export SSH_ASKPASS=/usr/bin/ksshaskpass
export SSH_ASKPASS_REQUIRE=prefer

export GOPATH="$HOME/.local/share/go"

HISTIGNORE="ls:history"

shopt -s huponexit
