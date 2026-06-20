# man
#export MANPAGER="sh -c \"col -bx | vim -c'colorscheme base16-cupcake' -c 'set ft=man nolist' -R -\""
export PAGER=more
export MANPAGER='NVIM_APPNAME=nvim-pde nvim +Man!'

# Supports bold/underline/etc
# See https://stackoverflow.com/a/4233818/9782020
# function man {
#     eval "unbuffer man -P cat \"$@\" | $MANPAGER"
# }

# No bold/underline/etc
function man {
    eval "command man \"$@\" | $MANPAGER"
}
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: man.sh
