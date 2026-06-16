# NVIM
export NDE_APP_NAME=nvim-pde
export NDE_APP_CONFIG=~/.config/$NDE_APP_NAME
export NVIM_LISTEN_ADDRESS=/tmp/neovim.socket
#export NDE_APP_NAME NDE_APP_CONFIG
export EDITOR=$(brew --prefix)/bin/nvim
export VISUAL=$EDITOR
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: editor.sh
