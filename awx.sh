# Bash completion for awx (Another wxWidgets Installer)
#
# Installation:
#   sudo cp awx-completion.bash /etc/bash_completion.d/awx
#   or
#   source awx-completion.bash

_awx_completion() {
    local cur prev words cword
    _init_completion || return

    # Comandos principais
    local commands="list-available list-installed install remove"

    # Plataformas disponíveis
    local platforms="linux windows android"

    # Versões conhecidas (pode manter estático ou sincronizar com o manifest depois)
    local versions="3.2.4 3.3.1"

    # Variantes por plataforma
    local linux_variants="cmake"
    local android_variants="arm64-v8a"

    # Flags globais
    local global_flags="--version --help --base-url --install-dir --debug"

    # Descobre posição do "comando" na linha (primeira palavra que não é flag)
    local cmd_pos=-1
    local i
    for ((i = 1; i < cword; i++)); do
        if [[ "${words[i]}" != -* ]]; then
            cmd_pos=$i
            break
        fi
    done

    # Se ainda não há comando (só flags até agora)
    if [[ $cmd_pos -eq -1 ]]; then
        # Estamos escolhendo o comando ou digitando flags globais
        if [[ "$cur" == -* ]]; then
            COMPREPLY=($(compgen -W "$global_flags" -- "$cur"))
        else
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        fi
        return 0
    fi

    local cmd="${words[cmd_pos]}"
    local shortcut_platform=""

    # Suporte ao atalho:
    #   awx linux 3.2.4  ≡  awx install linux 3.2.4
    if [[ " $platforms " == *" $cmd "* ]] && [[ " $commands " != *" $cmd "* ]]; then
        shortcut_platform="$cmd"
        cmd="install"
    fi

    # Se estamos na posição do comando (ex: "awx <TAB>")
    if [[ $cword -eq $cmd_pos ]]; then
        if [[ "$cur" == -* ]]; then
            COMPREPLY=($(compgen -W "$global_flags" -- "$cur"))
        else
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        fi
        return 0
    fi

    case "$cmd" in
        list-available | list-installed)
            # Esses comandos não têm argumentos adicionais
            COMPREPLY=()
            ;;

        install)
            # Para o atalho:
            #   awx linux 3.2.4
            # cmd_pos -> 'linux', então:
            #   platform_pos = cmd_pos
            #   version_pos  = cmd_pos + 1
            #   variant_pos  = cmd_pos + 2
            #
            # Para o normal:
            #   awx install linux 3.2.4
            # cmd_pos -> 'install', então:
            #   platform_pos = cmd_pos + 1
            #   version_pos  = cmd_pos + 2
            #   variant_pos  = cmd_pos + 3
            local platform_pos
            local version_pos
            local variant_pos

            if [[ -n "$shortcut_platform" ]]; then
                platform_pos=$cmd_pos
                version_pos=$((platform_pos + 1))
                variant_pos=$((platform_pos + 2))
            else
                platform_pos=$((cmd_pos + 1))
                version_pos=$((cmd_pos + 2))
                variant_pos=$((cmd_pos + 3))
            fi

            if [[ $cword -eq $platform_pos ]]; then
                # Completa plataforma
                COMPREPLY=($(compgen -W "$platforms" -- "$cur"))

            elif [[ $cword -eq $version_pos ]]; then
                # Completa versão
                COMPREPLY=($(compgen -W "$versions" -- "$cur"))

            elif [[ $cword -eq $variant_pos ]]; then
                # Completa variante baseado na plataforma
                local platform="${words[$platform_pos]}"
                case "$platform" in
                    linux)
                        COMPREPLY=($(compgen -W "$linux_variants" -- "$cur"))
                        ;;
                    android)
                        COMPREPLY=($(compgen -W "$android_variants" -- "$cur"))
                        ;;
                    windows)
                        # Windows não tem variantes
                        COMPREPLY=()
                        ;;
                    *)
                        COMPREPLY=()
                        ;;
                esac
            fi
            ;;

        remove)
            local remove_pos=$((cmd_pos + 1))
            local platform_pos=$remove_pos
            local version_pos=$((remove_pos + 1))
            local variant_pos=$((remove_pos + 2))

            if [[ $cword -eq $platform_pos ]]; then
                # Para remover, sempre sugerimos as plataformas válidas
                # (para evitar coisas inválidas tipo 'linux-cmake')
                COMPREPLY=($(compgen -W "$platforms" -- "$cur"))

            elif [[ $cword -eq $version_pos ]]; then
                # Completa versão baseado em instalações existentes para aquela plataforma
                local platform="${words[$platform_pos]}"
                local install_dir="${HOME}/.local/wxwidgets"

                # Tenta obter do --install-dir se especificado
                for ((i = 1; i < cword; i++)); do
                    if [[ "${words[i]}" == "--install-dir" ]]; then
                        install_dir="${words[i + 1]}"
                        break
                    fi
                done

                if [[ -d "$install_dir" ]]; then
                    # Diretórios no formato:
                    #   linux-wx-3.2.4
                    #   linux-cmake-wx-3.2.4
                    #   android-arm64-v8a-wx-3.2.4
                    local installed_versions
                    installed_versions=$(cd "$install_dir" 2>/dev/null &&
                        ls -d ${platform}*-wx-* 2>/dev/null 2>/dev/null |
                        sed 's/.*-wx-//' |
                            sort -u |
                            tr '\n' ' ')

                    if [[ -n "$installed_versions" ]]; then
                        COMPREPLY=($(compgen -W "$installed_versions" -- "$cur"))
                    else
                        COMPREPLY=($(compgen -W "$versions" -- "$cur"))
                    fi
                else
                    COMPREPLY=($(compgen -W "$versions" -- "$cur"))
                fi

            elif [[ $cword -eq $variant_pos ]]; then
                # Completa variante baseado na plataforma e instalações
                local platform="${words[$platform_pos]}"
                local version="${words[$version_pos]}"
                local install_dir="${HOME}/.local/wxwidgets"

                for ((i = 1; i < cword; i++)); do
                    if [[ "${words[i]}" == "--install-dir" ]]; then
                        install_dir="${words[i + 1]}"
                        break
                    fi
                done

                case "$platform" in
                    linux)
                        # Para linux, só tem 'cmake' como variante conhecida
                        if [[ -d "$install_dir" ]]; then
                            if [[ -d "$install_dir/linux-cmake-wx-${version}" ]]; then
                                COMPREPLY=($(compgen -W "cmake" -- "$cur"))
                            else
                                COMPREPLY=()
                            fi
                        else
                            COMPREPLY=($(compgen -W "$linux_variants" -- "$cur"))
                        fi
                        ;;
                    android)
                        if [[ -d "$install_dir" ]]; then
                            # Diretórios android no formato:
                            #   android-arm64-v8a-wx-3.2.4
                            local variants
                            variants=$(cd "$install_dir" 2>/dev/null &&
                                ls -d android-*-wx-${version} 2>/dev/null |
                                sed -E "s/^android-([^ ]*)-wx-${version}$/\1/" |
                                    sort -u |
                                    tr '\n' ' ')

                            if [[ -n "$variants" ]]; then
                                COMPREPLY=($(compgen -W "$variants" -- "$cur"))
                            else
                                COMPREPLY=($(compgen -W "$android_variants" -- "$cur"))
                            fi
                        else
                            COMPREPLY=($(compgen -W "$android_variants" -- "$cur"))
                        fi
                        ;;
                    *)
                        COMPREPLY=()
                        ;;
                esac
            fi
            ;;

        *)
            # Comando desconhecido
            COMPREPLY=()
            ;;
    esac

    return 0
}

# Registra a função de completion
complete -F _awx_completion awx

# DEBUG opcional do próprio script de completion
[ "$SCRIPT_DEBUG_ON" ] && echo "awx.sh"
