# rbenv
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$PATH:$RBENV_ROOT/bin"
eval "$(rbenv init - bash)"

ruby_version=$(rbenv version-name)
echo "Ruby versão $ruby_version está ativa"

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: rbenv.sh
	rbenv version
}
