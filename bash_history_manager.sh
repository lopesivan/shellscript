#!/usr/bin/env bash
# Script para gerenciar histórico do bash em SQLite

DB_FILE="$HOME/.bash_history.db"

# Função para criar o banco de dados
create_db() {
    sqlite3 "$DB_FILE" <<EOF
CREATE TABLE IF NOT EXISTS commands (
    command TEXT PRIMARY KEY
);
EOF
    echo "Banco de dados criado em: $DB_FILE"
}

# Função para importar histórico existente
import_history() {
    echo "Importando histórico existente..."
    local count=0

    while IFS= read -r cmd; do
        # Ignora linhas vazias
        [[ -z "$cmd" ]] && continue

        # Escapa aspas simples
        cmd=$(echo "$cmd" | sed "s/'/''/g")

        sqlite3 "$DB_FILE" "INSERT OR IGNORE INTO commands (command) VALUES ('$cmd');"
        ((count++))
    done <"$HOME/.bash_history"

    local total=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM commands;")
    echo "Processados $count comandos, $total únicos no banco"
}

# Função para adicionar comando atual
add_command() {
    local cmd="$1"
    [[ -z "$cmd" ]] && return

    # Escapa aspas simples
    cmd=$(echo "$cmd" | sed "s/'/''/g")

    sqlite3 "$DB_FILE" "INSERT OR IGNORE INTO commands (command) VALUES ('$cmd');"
}

# Função para buscar no histórico
search_history() {
    local query="$1"

    if [[ -z "$query" ]]; then
        echo "Comandos no banco (últimos 50):"
        sqlite3 -column "$DB_FILE" "SELECT command FROM commands LIMIT 50;"
    else
        echo "Buscando por: $query"
        sqlite3 -column "$DB_FILE" "SELECT command FROM commands WHERE command LIKE '%$query%';"
    fi
}

# Função para estatísticas
stats() {
    echo "=== Estatísticas do Histórico ==="
    echo ""
    echo "Total de comandos únicos:"
    sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM commands;"
    echo ""
    echo "Comandos que começam com cada letra:"
    sqlite3 -column -header "$DB_FILE" "SELECT UPPER(SUBSTR(command,1,1)) as letra, COUNT(*) as total FROM commands GROUP BY letra ORDER BY total DESC LIMIT 10;"
}

# Função para limpar duplicatas
clean_duplicates() {
    echo "Banco já mantém apenas comandos únicos automaticamente"
    stats
}

# Menu principal
case "$1" in
    init)
        create_db
        import_history
        ;;
    search | s)
        search_history "$2"
        ;;
    add)
        add_command "$2"
        ;;
    stats)
        stats
        ;;
    clean)
        clean_duplicates
        ;;
    export)
        echo "Exportando histórico para bash_history_export.txt..."
        sqlite3 "$DB_FILE" "SELECT command FROM commands;" >bash_history_export.txt
        echo "Exportado para bash_history_export.txt"
        ;;
    *)
        echo "Uso: $0 {init|search|add|stats|clean|export}"
        echo ""
        echo "Comandos:"
        echo "  init              - Cria banco e importa histórico existente"
        echo "  search [termo]    - Busca comandos (sem termo = mostra 50)"
        echo "  add 'comando'     - Adiciona comando manualmente"
        echo "  stats             - Mostra estatísticas"
        echo "  clean             - Info sobre unicidade"
        echo "  export            - Exporta para arquivo texto"
        echo ""
        echo "Exemplos:"
        echo "  $0 init"
        echo "  $0 search git"
        echo "  $0 search"
        echo "  $0 stats"
        ;;
esac
