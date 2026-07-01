# Bash completion para git-server.api
#
# Instalação:
#   cp git-server.api-completion.bash /etc/bash_completion.d/git-server.api
# ou, apenas para o seu usuário:
#   mkdir -p ~/.local/share/bash-completion/completions
#   cp git-server.api-completion.bash ~/.local/share/bash-completion/completions/git-server.api
# ou ainda, direto no ~/.bashrc:
#   source /caminho/para/git-server.api-completion.bash

_git_server_api_repos() {
    # Lista os repositórios existentes chamando o próprio comando.
    # Ajuste aqui se a saída de "list" tiver cabeçalho/formatação extra.
    git-server.api list 2>/dev/null
}

_git_server_api() {
    local cur prev words cword
    _init_completion || {
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD - 1]}"
    }

    local commands="new create publish push rm clone info about exists list url set-description"

    # Primeiro argumento: nome do subcomando
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        return 0
    fi

    local subcmd="${COMP_WORDS[1]}"

    case "$subcmd" in
        new)
            # git-server.api new <repo> -- repo novo, não completa (ainda não existe)
            return 0
            ;;
        create | publish | clone | info | about | exists | url)
            # git-server.api <cmd> [repo] -- completa com repos existentes
            if [[ $COMP_CWORD -eq 2 ]]; then
                COMPREPLY=($(compgen -W "$(_git_server_api_repos)" -- "$cur"))
            fi
            return 0
            ;;
        rm)
            # git-server.api rm <repo> [--force]
            if [[ $COMP_CWORD -eq 2 ]]; then
                COMPREPLY=($(compgen -W "$(_git_server_api_repos)" -- "$cur"))
            elif [[ $COMP_CWORD -eq 3 ]]; then
                COMPREPLY=($(compgen -W "--force" -- "$cur"))
            fi
            return 0
            ;;
        set-description)
            # git-server.api set-description [repo] <texto>
            if [[ $COMP_CWORD -eq 2 ]]; then
                COMPREPLY=($(compgen -W "$(_git_server_api_repos)" -- "$cur"))
            fi
            # a partir daqui é texto livre, sem completion
            return 0
            ;;
        push | list)
            # sem argumentos adicionais
            return 0
            ;;
        *)
            return 0
            ;;
    esac
}

complete -F _git_server_api git-server.api

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: git_server_api.sh
