# dotnet

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$DOTNET_ROOT:$PATH

function _dotnet_bash_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n'
    local candidates

    read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)

    read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
}

complete -f -F _dotnet_bash_complete dotnet
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: dotnet.sh
