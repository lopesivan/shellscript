# Função de autocompletar para 'git tools'
# O nome da função deve seguir o padrão: _<comando>
_git_tools_completion() {
    local cur prev opts commands subcommands

    # 1. Obtém a palavra atual (o que o usuário está digitando) e a anterior
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"

    # Define a lista de comandos principais disponíveis
    commands="init populate search list clone stats help"

    # Se a palavra anterior for 'git', 'tools', ou um dos comandos principais
    # a ser ignorado (que já definimos acima), o subcomando é o argumento 1
    if [ "$COMP_CWORD" -eq 2 ]; then
        # Estamos autocompletando o primeiro argumento (subcomando)
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        return 0
    fi

    # 2. Lógica para argumentos de subcomandos

    # Obtém o subcomando que está sendo executado (o segundo argumento, índice 2)
    subcommand="${COMP_WORDS[2]}"

    case "${subcommand}" in
        # Comandos que não precisam de argumentos adicionais
        init | populate | list | stats | help)
            # Se for um desses comandos, não há mais nada para autocompletar
            COMPREPLY=()
            ;;

        # Comandos que precisam de argumentos (clone, search)
        search)
            # Para 'search', esperamos um termo. Não há lista fixa de sugestões.
            # Podemos sugerir arquivos/diretórios como fallback, mas não é ideal.
            COMPREPLY=()
            ;;

        clone)
            # Esperamos o nome do repositório (primeiro argumento)
            # Como não temos uma lista dinâmica de repositórios do DB,
            # não podemos sugerir nomes.

            if [ "$COMP_CWORD" -eq 3 ]; then
                # Se for o terceiro argumento (o nome do repositório),
                # deixamos vazio (poderia ser uma lista de nomes do DB se disponível)
                COMPREPLY=()
            elif [ "$COMP_CWORD" -eq 4 ]; then
                # Se for o quarto argumento (o tipo de clone)
                subcommands="ssh"
                COMPREPLY=($(compgen -W "$subcommands" -- "$cur"))
            fi
            ;;

        *)
            # Subcomando inválido
            COMPREPLY=()
            ;;
    esac
}

# 3. Associa a função de autocompletar ao comando 'git tools'
# Como o comando é chamado como 'git tools', precisamos que ele funcione para o comando 'git'
# especificamente quando 'tools' é o subcomando do git.

# O Bash usa o comando inteiro (incluindo o caminho) como o nome da função
# Para o seu caso (git tools), a maneira mais confiável é usar o 'complete -F'
# no nome do executável completo ou no nome do alias.

# 💡 SOLUÇÃO MAIS SIMPLES: Tratar 'git' como o comando e verificar 'tools'

# Esta função de fallback garante que o autocompletar só seja acionado
# se o comando for 'git' e o primeiro subcomando for 'tools'.
_git_tools_main() {
    # Verifica se o primeiro subcomando (índice 1) é 'tools'
    if [ "${COMP_WORDS[1]}" = "tools" ]; then
        # Se for 'git tools', chamamos a função específica
        _git_tools_completion
    else
        # Caso contrário, usamos a autocompleção padrão do git
        _git_tools # Não chame a função, use a autocompleção padrão (se existir)
    fi
}

# 4. Registra a função de autocompletar
# O comando que o usuário digita primeiro é 'git'
complete -F _git_tools_completion git

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: git_tools.sh
