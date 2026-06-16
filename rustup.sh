# rust
export PATH="$PATH:$(brew --prefix)/opt/rustup/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"

eval "$(rustup completions bash)"
eval "$(rustup completions bash cargo)"

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: rustup.sh
	rustup -V
}
