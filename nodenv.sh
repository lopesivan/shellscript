# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

js_version=$(nodenv version-name)
echo "Node versão $js_version está ativa"

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: nodenv.sh
	nodenv version
}
