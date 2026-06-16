# Bash completion for amp (Android Manager Platforms)
#
# Installation:
#   sudo cp amp-completion.bash /etc/bash_completion.d/amp
#   or
#   source amp-completion.bash

_amp_completion() {
    local cur prev words cword
    _init_completion || return

    # Comandos principais
    local commands="list activate clear profile-list profile-save profile-load profile-show profile-delete interactive status"

    # Flags globais
    local global_flags="--help -h"

    # Descobre posição do primeiro comando (primeira palavra que não é flag)
    local cmd_pos=-1
    local i
    for ((i = 1; i < cword; i++)); do
        if [[ "${words[i]}" != -* ]]; then
            cmd_pos=$i
            break
        fi
    done

    # Ainda não há comando — completa comandos ou flags globais
    if [[ $cmd_pos -eq -1 ]]; then
        if [[ "$cur" == -* ]]; then
            COMPREPLY=($(compgen -W "$global_flags" -- "$cur"))
        else
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        fi
        return 0
    fi

    local cmd="${words[$cmd_pos]}"

    # Se estamos exatamente na posição do comando, completa comandos
    if [[ $cword -eq $cmd_pos ]]; then
        if [[ "$cur" == -* ]]; then
            COMPREPLY=($(compgen -W "$global_flags" -- "$cur"))
        else
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        fi
        return 0
    fi

    # -------------------------------------------------------------------------
    # Helper: lista plataformas disponíveis em platforms-all
    # -------------------------------------------------------------------------
    _amp_available_platforms() {
        local sdk="${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}"
        local platforms_all="$sdk/platforms-all"
        if [[ -d "$platforms_all" ]]; then
            ls -1 "$platforms_all" 2>/dev/null | sort -V | tr '\n' ' '
        fi
    }

    # Helper: lista perfis salvos
    _amp_saved_profiles() {
        local sdk="${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}"
        local profiles_dir="$sdk/.platform-profiles"
        if [[ -d "$profiles_dir" ]]; then
            ls -1 "$profiles_dir" 2>/dev/null | sed 's/\.profile$//' | tr '\n' ' '
        fi
    }

    case "$cmd" in

        # ── list / status / clear / interactive ──────────────────────────────
        # Sem argumentos adicionais
        list | status | clear | interactive | profile-list)
            COMPREPLY=()
            ;;

        # ── activate <platform...> ────────────────────────────────────────────
        # Permite múltiplas plataformas; sempre sugere todas as disponíveis
        # (o usuário pode repetir o TAB para adicionar mais plataformas)
        activate)
            local available
            available=$(_amp_available_platforms)
            COMPREPLY=($(compgen -W "$available" -- "$cur"))
            ;;

        # ── profile-save <name> <platform...> ────────────────────────────────
        # Posição cmd_pos+1 = nome do perfil (texto livre)
        # Posição cmd_pos+2 em diante = plataformas (com sugestão)
        profile-save)
            local name_pos=$((cmd_pos + 1))
            local platform_pos=$((cmd_pos + 2))

            if [[ $cword -eq $name_pos ]]; then
                # Nome do perfil: texto livre, sem sugestões
                COMPREPLY=()
            elif [[ $cword -ge $platform_pos ]]; then
                # Plataformas: sugere todas as disponíveis
                local available
                available=$(_amp_available_platforms)
                COMPREPLY=($(compgen -W "$available" -- "$cur"))
            fi
            ;;

        # ── profile-load <name> ───────────────────────────────────────────────
        profile-load)
            local name_pos=$((cmd_pos + 1))
            if [[ $cword -eq $name_pos ]]; then
                local profiles
                profiles=$(_amp_saved_profiles)
                COMPREPLY=($(compgen -W "$profiles" -- "$cur"))
            else
                COMPREPLY=()
            fi
            ;;

        # ── profile-show <name> ───────────────────────────────────────────────
        profile-show)
            local name_pos=$((cmd_pos + 1))
            if [[ $cword -eq $name_pos ]]; then
                local profiles
                profiles=$(_amp_saved_profiles)
                COMPREPLY=($(compgen -W "$profiles" -- "$cur"))
            else
                COMPREPLY=()
            fi
            ;;

        # ── profile-delete <name> ─────────────────────────────────────────────
        profile-delete)
            local name_pos=$((cmd_pos + 1))
            if [[ $cword -eq $name_pos ]]; then
                local profiles
                profiles=$(_amp_saved_profiles)
                COMPREPLY=($(compgen -W "$profiles" -- "$cur"))
            else
                COMPREPLY=()
            fi
            ;;

        # ── Legacy: plataforma diretamente (amp android-34) ──────────────────
        *)
            # Se o "comando" for uma plataforma válida, é o modo legado —
            # sem argumentos adicionais após a plataforma
            local available
            available=$(_amp_available_platforms)
            if [[ " $available " == *" $cmd "* ]]; then
                COMPREPLY=()
            else
                # Comando desconhecido — sugere comandos válidos
                COMPREPLY=($(compgen -W "$commands" -- "$cur"))
            fi
            ;;
    esac

    return 0
}

# Registra a função de completion
complete -F _amp_completion amp

# DEBUG opcional
[ "$SCRIPT_DEBUG_ON" ] && echo "amp-completion.bash loaded"

