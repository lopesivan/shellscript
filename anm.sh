# Bash completion for anm (Android NDK Manager)
#
# Installation:
#   sudo cp anm-completion.bash /etc/bash_completion.d/anm
#   or
#   source anm-completion.bash

_anm_completion() {
    local cur prev words cword
    _init_completion || return

    local commands="status list-remote list-installed install remove download cache-list cache-clear interactive"
    local global_flags="--help -h"

    # Descobre posição do primeiro comando
    local cmd_pos=-1
    local i
    for ((i = 1; i < cword; i++)); do
        if [[ "${words[i]}" != -* ]]; then
            cmd_pos=$i
            break
        fi
    done

    # Ainda sem comando
    if [[ $cmd_pos -eq -1 ]]; then
        if [[ "$cur" == -* ]]; then
            COMPREPLY=($(compgen -W "$global_flags" -- "$cur"))
        else
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        fi
        return 0
    fi

    local cmd="${words[$cmd_pos]}"

    # Cursor ainda no comando
    if [[ $cword -eq $cmd_pos ]]; then
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        return 0
    fi

    # -------------------------------------------------------------------------
    # Helper: versões instaladas localmente
    # -------------------------------------------------------------------------
    _anm_installed() {
        local ndk_dir="${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}/ndk"
        if [[ -d "$ndk_dir" ]]; then
            find "$ndk_dir" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" \
                2>/dev/null | sort -V | tr '\n' ' '
        fi
    }

    # Helper: versões disponíveis no servidor (com cache de 5 min)
    _anm_remote() {
        local base_url="${ANM_BASE_URL:-http://wxwidgets.com.br:8899/ndk}"
        local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/anm/.completion_cache"
        local now
        now=$(date +%s)

        if [[ -f "$cache_file" ]]; then
            local mtime
            mtime=$(stat -c %Y "$cache_file" 2>/dev/null || echo 0)
            if ((now - mtime < 300)); then
                cat "$cache_file"
                return
            fi
        fi

        local versions
        versions=$(curl -sf "$base_url/" 2>/dev/null |
            grep -oP 'ndk_[A-Za-z0-9][A-Za-z0-9._-]+\.tar\.xz\.[a-z]+' |
            sed -E 's|^ndk_||; s|\.tar\.xz\.[a-z]+$||' |
            sort -Vu | tr '\n' ' ')

        if [[ -n "$versions" ]]; then
            mkdir -p "$(dirname "$cache_file")"
            echo "$versions" >"$cache_file"
            echo "$versions"
        fi
    }

    # Helper: partes em cache local
    _anm_cached_versions() {
        local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/anm"
        if [[ -d "$cache_dir" ]]; then
            find "$cache_dir" -name 'ndk_*.tar.xz.*' -printf "%f\n" 2>/dev/null |
                grep -oP 'ndk_\K[0-9]+\.[0-9]+\.[0-9]+(?=\.tar\.xz)' |
                sort -Vu | tr '\n' ' '
        fi
    }

    case "$cmd" in

        # Sem argumentos
        status | list-remote | list-installed | interactive | cache-list)
            COMPREPLY=()
            ;;

        # install <version> — versões remotas
        install)
            local arg_pos=$((cmd_pos + 1))
            if [[ $cword -eq $arg_pos ]]; then
                local remote
                remote=$(_anm_remote)
                COMPREPLY=($(compgen -W "$remote" -- "$cur"))
            else
                COMPREPLY=()
            fi
            ;;

        # remove <version> — versões instaladas localmente
        remove)
            local arg_pos=$((cmd_pos + 1))
            if [[ $cword -eq $arg_pos ]]; then
                local installed
                installed=$(_anm_installed)
                COMPREPLY=($(compgen -W "$installed" -- "$cur"))
            else
                COMPREPLY=()
            fi
            ;;

        # download <version> — versões remotas ainda não instaladas
        download)
            local arg_pos=$((cmd_pos + 1))
            if [[ $cword -eq $arg_pos ]]; then
                local remote
                remote=$(_anm_remote)
                COMPREPLY=($(compgen -W "$remote" -- "$cur"))
            else
                COMPREPLY=()
            fi
            ;;

        # cache-clear [version] — versões que têm partes em cache
        cache-clear)
            local arg_pos=$((cmd_pos + 1))
            if [[ $cword -eq $arg_pos ]]; then
                local cached
                cached=$(_anm_cached_versions)
                COMPREPLY=($(compgen -W "$cached" -- "$cur"))
            else
                COMPREPLY=()
            fi
            ;;

        *)
            COMPREPLY=()
            ;;
    esac

    return 0
}

complete -F _anm_completion anm

[ "$SCRIPT_DEBUG_ON" ] && echo "anm-completion.bash loaded"
