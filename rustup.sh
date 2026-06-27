# rust
export PATH="$PATH:$(brew --prefix)/opt/rustup/bin"
export PATH="$PATH:${HOME}/.cargo/bin"

eval "$(rustup completions bash)"
eval "$(rustup completions bash cargo)"

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
    echo load file: rustup.sh
    rustup -V
}
