# pyenv

PYENV_ROOT="$HOME/.pyenv"

[[ $(which pyenv 2>/dev/null) ]] && eval "$(pyenv init --path)"
[[ $(which pyenv 2>/dev/null) ]] && eval "$(pyenv init -)"

python_version=$(pyenv version-name)
echo "Python versão $python_version está ativa"

##Load pyenv virtualenv if the virtualenv plugin is installed.
# if pyenv virtualenv-init - &>/dev/null; then
# 	eval "$(pyenv virtualenv-init - bash)"
# fi

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: pyenv.sh
	pyenv version
}
