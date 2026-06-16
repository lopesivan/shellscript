dir_target=$HOME/.luaenv/bin
if [[ -d "$dir_target" ]]; then
	export PATH=$dir_target:$PATH
fi

eval "$(luaenv init -)"

# Obter a versão do luaenv
lua_version=$(luaenv version-name)

dir_target=$HOME/.config/luarock/${lua_version}/bin
if [[ -d "$dir_target" ]]; then
	export PATH=$dir_target:$PATH

fi

eval "$(luarocks path --bin)"
eval "$(luarocks completion bash)"
#luarocks path

# Mostrando a instalacao:
# luarocks install numlua FFTW3_DIR=/home/linuxbrew/.linuxbrew/Cellar/fftw/3.3.10_1 HDF5_DIR=/home/linuxbrew/.linuxbrew/Cellar/hdf5/1.14.4.3

echo "Lua versão $lua_version está ativa"

[ $SCRIPT_DEBUG_ON ] && {
	echo load file: lua.sh
	luarocks --version
}
