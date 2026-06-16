# goenv
eval "$(goenv init - bash)"
export PATH=${GOENV_ROOT}/versions/"$(goenv version-name)"/bin:$PATH

go_version=$(goenv version-name)
echo "Go versão $go_version está ativa"

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: goenv.sh
	goenv version
}
