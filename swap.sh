#!/usr/bin/env bash
set -euo pipefail

link="apm.sh"
target1="apm.sh.1"
target2="apm.sh.2"

current="$(readlink "$link")"

case "$current" in
    "$target1") next="$target2" ;;
    "$target2") next="$target1" ;;
    *)
        echo "erro: link aponta para destino desconhecido: $current" >&2
        exit 1
        ;;
esac

ln -sf "$next" "$link"
echo "$link: $current -> $next"
