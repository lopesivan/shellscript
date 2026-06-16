NVIM=$(command -v nvim)
NANO=$(command -v nano)

[[ $NVIM ]] && {
    alias e=envim.sh
    alias vim=nvim.sh
    alias n=nvim-nova.sh
    alias v="vim"

    #alias v="NVIM_APPNAME=nvim-pde nvim"
    alias vim-rplug-install="v +UpdateRemotePlugins +qall"
    alias vim-plug-install="v +PlugInstall +qall"
    alias vim-frecency="v -c:FrecencyValidate"

}

[[ -n $NANO ]] && { alias nano='nano -licgmLD -T4 '; }
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: nvim.sh
