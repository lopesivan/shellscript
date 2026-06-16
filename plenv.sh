# plenv

dir_target=$HOME/.plenv/bin
if [[ -d "$dir_target" ]]; then
	export PATH=$dir_target:$PATH
fi

eval "$(plenv init - bash)"

perl_version=$(plenv version-name)

export PATH=$(plenv root)/versions/${perl_version}/bin:$PATH

echo "Perl versão $perl_version está ativa"

[ $SCRIPT_DEBUG_ON ] && echo load file: plenv.sh
