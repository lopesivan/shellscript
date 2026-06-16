#!/usr/bin/env python3
"""
Gerenciador de Histórico do Bash com SQLite
Armazena comandos únicos sem limite de 1000 linhas
"""

from __future__ import annotations

import argparse
import re
import sqlite3
import sys
from datetime import datetime
from pathlib import Path
from typing import Iterable, Optional


class HistoryManager:
    def __init__(self, db_path: Optional[str] = None) -> None:
        self.db_path = Path(db_path).expanduser(
        ) if db_path else Path.home() / ".bash_history.db"
        self.history_file = Path.home() / ".bash_history"
        self.conn: Optional[sqlite3.Connection] = None

    def __enter__(self) -> "HistoryManager":
        self.conn = sqlite3.connect(str(self.db_path))
        self.conn.row_factory = sqlite3.Row
        self._configure_connection()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb) -> None:
        if self.conn is not None:
            self.conn.close()
            self.conn = None

    def _configure_connection(self) -> None:
        assert self.conn is not None
        self.conn.execute("PRAGMA journal_mode=WAL")
        self.conn.execute("PRAGMA synchronous=NORMAL")
        self.conn.create_function("REGEXP", 2, self._sqlite_regexp)

    @staticmethod
    def _sqlite_regexp(pattern: str, value: Optional[str]) -> int:
        if value is None:
            return 0
        try:
            return 1 if re.search(pattern, value) else 0
        except re.error:
            return 0

    def _cursor(self) -> sqlite3.Cursor:
        if self.conn is None:
            raise RuntimeError("Conexão com o banco não inicializada")
        return self.conn.cursor()

    def _conn(self) -> sqlite3.Connection:
        if self.conn is None:
            raise RuntimeError("Conexão não inicializada")
        return self.conn

    def create_db(self, verbose: bool = True) -> None:
        cursor = self._cursor()
        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS commands (
                command TEXT PRIMARY KEY NOT NULL,
                first_seen TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                last_seen TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """
        )
        cursor.execute(
            """
            CREATE INDEX IF NOT EXISTS idx_commands_last_seen
            ON commands(last_seen DESC)
            """
        )

        conn = self._conn()
        conn.commit()

        if verbose:
            print(f"✓ Banco de dados criado/verificado: {self.db_path}")

    @staticmethod
    def _normalize_command(command: str) -> str:
        return command.rstrip("\n")

    @staticmethod
    def _should_ignore_command(command: str) -> bool:
        if not command:
            return True
        if len(command.strip()) < 2:
            return True
        if command.startswith(" "):
            return True
        return False

    def add_command(
        self,
        command: str,
        update_last_seen: bool = True,
        *,
        auto_commit: bool = True,
    ) -> bool:
        """
        Adiciona um comando ao banco.

        Returns:
            True se foi inserido pela primeira vez.
            False se já existia.
        """
        normalized = self._normalize_command(command)

        if self._should_ignore_command(normalized):
            return False

        cursor = self._cursor()
        already_exists = cursor.execute(
            "SELECT 1 FROM commands WHERE command = ?",
            (normalized,),
        ).fetchone() is not None

        if already_exists:
            if update_last_seen:
                cursor.execute(
                    """
                    UPDATE commands
                    SET last_seen = CURRENT_TIMESTAMP
                    WHERE command = ?
                    """,
                    (normalized,),
                )

            conn = self._conn()
            if auto_commit:
                conn.commit()
            return False

        cursor.execute(
            """
            INSERT INTO commands (command, first_seen, last_seen)
            VALUES (?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            """,
            (normalized,),
        )

        conn = self._conn()
        if auto_commit:
            conn.commit()

        return True

    def import_history(self, verbose: bool = True) -> tuple[int, int]:
        if not self.history_file.exists():
            print(f"✗ Arquivo não encontrado: {self.history_file}")
            return (0, 0)

        total = 0
        added = 0

        try:
            assert self.conn is not None
            with self.conn:
                with self.history_file.open("r", encoding="utf-8", errors="ignore") as f:
                    for line in f:
                        command = line.rstrip("\n")
                        if not command.strip():
                            continue
                        total += 1
                        if self.add_command(command, update_last_seen=False, auto_commit=False):
                            added += 1

            if verbose:
                print(f"✓ Processados: {total} comandos")
                print(f"✓ Novos adicionados: {added}")
                print(f"✓ Total único no banco: {self.count()}")

            return (total, added)

        except OSError as e:
            print(f"✗ Erro ao ler histórico: {e}", file=sys.stderr)
            return (0, 0)
        except sqlite3.Error as e:
            print(f"✗ Erro ao importar histórico: {e}", file=sys.stderr)
            return (0, 0)

    def search(self, query: Optional[str] = None, limit: int = 50) -> list[str]:
        cursor = self._cursor()

        if not query or not query.strip():
            rows = cursor.execute(
                """
                SELECT command
                FROM commands
                ORDER BY last_seen DESC
                LIMIT ?
                """,
                (limit,),
            ).fetchall()
        else:
            rows = cursor.execute(
                """
                SELECT command
                FROM commands
                WHERE command LIKE ?
                ORDER BY last_seen DESC
                LIMIT ?
                """,
                (f"%{query}%", limit),
            ).fetchall()

        return [row["command"] for row in rows]

    def search_with_timestamps(
        self,
        query: Optional[str] = None,
        limit: int = 50,
    ) -> list[tuple[str, str]]:
        cursor = self._cursor()

        if not query or not query.strip():
            rows = cursor.execute(
                """
                SELECT last_seen, command
                FROM commands
                ORDER BY last_seen DESC
                LIMIT ?
                """,
                (limit,),
            ).fetchall()
        else:
            rows = cursor.execute(
                """
                SELECT last_seen, command
                FROM commands
                WHERE command LIKE ?
                ORDER BY last_seen DESC
                LIMIT ?
                """,
                (f"%{query}%", limit),
            ).fetchall()

        return [(row["last_seen"], row["command"]) for row in rows]

    def list_commands(self, limit: int = 50, reverse: bool = True) -> list[tuple[str, str]]:
        cursor = self._cursor()
        order = "DESC" if reverse else "ASC"
        rows = cursor.execute(
            f"""
            SELECT last_seen, command
            FROM commands
            ORDER BY last_seen {order}
            LIMIT ?
            """,
            (limit,),
        ).fetchall()

        return [(row["last_seen"], row["command"]) for row in rows]

    def search_regex(self, pattern: str, limit: int = 50) -> list[str]:
        cursor = self._cursor()
        rows = cursor.execute(
            """
            SELECT command
            FROM commands
            WHERE command REGEXP ?
            ORDER BY last_seen DESC
            LIMIT ?
            """,
            (pattern, limit),
        ).fetchall()

        return [row["command"] for row in rows]

    def count(self) -> int:
        row = self._cursor().execute("SELECT COUNT(*) AS total FROM commands").fetchone()
        return int(row["total"])

    def stats(self) -> None:
        cursor = self._cursor()

        print("\n" + "=" * 60)
        print("ESTATÍSTICAS DO HISTÓRICO")
        print("=" * 60)

        total = self.count()
        print(f"\n📊 Total de comandos únicos: {total:,}")

        oldest = cursor.execute(
            """
            SELECT command, first_seen
            FROM commands
            ORDER BY first_seen ASC
            LIMIT 1
            """
        ).fetchone()
        if oldest:
            print(f"📅 Comando mais antigo: {oldest['first_seen']}")

        newest = cursor.execute(
            """
            SELECT command, last_seen
            FROM commands
            ORDER BY last_seen DESC
            LIMIT 1
            """
        ).fetchone()
        if newest:
            print(f"📅 Último comando: {newest['last_seen']}")

        print("\n📈 Distribuição por primeira letra (top 10):")
        for row in cursor.execute(
            """
            SELECT UPPER(SUBSTR(command, 1, 1)) AS letra,
                   COUNT(*) AS total
            FROM commands
            GROUP BY letra
            ORDER BY total DESC
            LIMIT 10
            """
        ).fetchall():
            letra = row["letra"] if row["letra"] else "?"
            print(f"   {letra}: {row['total']:,}")

        print("\n📏 Comandos mais longos:")
        for row in cursor.execute(
            """
            SELECT command, LENGTH(command) AS len
            FROM commands
            ORDER BY len DESC
            LIMIT 5
            """
        ).fetchall():
            cmd = row["command"]
            if len(cmd) > 70:
                cmd = cmd[:70] + "..."
            print(f"   [{row['len']}] {cmd}")

        print("\n" + "=" * 60 + "\n")

    def export(self, output_file: str) -> None:
        cursor = self._cursor()
        rows = cursor.execute(
            """
            SELECT command
            FROM commands
            ORDER BY command
            """
        ).fetchall()

        try:
            with open(output_file, "w", encoding="utf-8") as f:
                for row in rows:
                    f.write(row["command"] + "\n")
            print(f"✓ Exportados {len(rows):,} comandos para: {output_file}")
        except OSError as e:
            print(f"✗ Erro ao exportar: {e}", file=sys.stderr)

    @staticmethod
    def _escape_like(pattern: str) -> str:
        return (
            pattern.replace("\\", "\\\\")
            .replace("%", "\\%")
            .replace("_", "\\_")
        )

    def delete_pattern(self, pattern: str) -> int:
        escaped = self._escape_like(pattern)
        cursor = self._cursor()
        cursor.execute(
            """
            DELETE FROM commands
            WHERE command LIKE ? ESCAPE '\\'
            """,
            (f"%{escaped}%",),
        )
        deleted = cursor.rowcount

        conn = self._conn()
        conn.commit()

        print(f"✓ Removidos {deleted} comandos contendo: '{pattern}'")
        return deleted

    def clear_all(self) -> None:
        self._cursor().execute("DELETE FROM commands")
        conn = self._conn()
        conn.commit()

    @staticmethod
    def format_timestamp(timestamp: str) -> str:
        try:
            dt = datetime.fromisoformat(timestamp)
        except ValueError:
            try:
                dt = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
            except ValueError:
                return timestamp
        return dt.strftime("%Y-%m-%d %H:%M:%S")


def print_commands(commands: Iterable[str]) -> None:
    for cmd in commands:
        print(f"  {cmd}")
    print()


def print_timestamped_commands(rows: Iterable[tuple[str, str]]) -> None:
    for timestamp, cmd in rows:
        time_str = HistoryManager.format_timestamp(timestamp)
        print(f"  [{time_str}] {cmd}")
    print()


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Gerenciador de Histórico do Bash",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  %(prog)s init                    # Inicializa e importa histórico
  %(prog)s add "ls -la"            # Adiciona comando
  %(prog)s search git              # Busca por 'git'
  %(prog)s search                  # Mostra últimos 50
  %(prog)s ls                      # Lista entradas sem ordenação
  %(prog)s ls --limit 100          # Lista 100 entradas
  %(prog)s last                    # Últimas 12 entradas
  %(prog)s last --limit 20         # Últimas 20 entradas
  %(prog)s stats                   # Estatísticas
  %(prog)s export history.txt      # Exporta tudo
  %(prog)s delete "senha"          # Remove comandos com 'senha'
        """,
    )

    parser.add_argument(
        "action",
        choices=["init", "add", "search", "ls", "last",
                 "stats", "export", "delete", "clear"],
        help="Ação a executar",
    )
    parser.add_argument("args", nargs="*", help="Argumentos da ação")
    parser.add_argument("--db", type=str, help="Caminho customizado do banco")
    parser.add_argument("--limit", type=int, default=50,
                        help="Limite de resultados (padrão: 50)")
    parser.add_argument(
        "--timestamps",
        "-t",
        action="store_true",
        help="Mostra timestamps nos resultados",
    )

    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    with HistoryManager(args.db) as hm:
        hm.create_db()

        if args.action == "init":
            hm.import_history()
            return

        if args.action == "add":
            if not args.args:
                print("✗ Erro: especifique o comando a adicionar")
                sys.exit(1)

            command = " ".join(args.args)
            inserted = hm.add_command(command)
            if inserted:
                print(f"✓ Comando adicionado: {command}")
            else:
                print(f"ℹ️  Comando já existe: {command}")
            return

        if args.action == "search":
            query = " ".join(args.args) if args.args else None

            if args.timestamps:
                results = hm.search_with_timestamps(query, limit=args.limit)
                if results:
                    if query:
                        print(
                            f"\n🔍 Resultados para '{query}' ({len(results)}):\n")
                    else:
                        print(f"\n📋 Últimos comandos ({len(results)}):\n")
                    print_timestamped_commands(results)
                else:
                    print("✗ Nenhum resultado encontrado")
            else:
                results = hm.search(query, limit=args.limit)
                if results:
                    if query:
                        print(
                            f"\n🔍 Resultados para '{query}' ({len(results)}):\n")
                    else:
                        print(f"\n📋 Últimos comandos ({len(results)}):\n")
                    print_commands(results)
                else:
                    print("✗ Nenhum resultado encontrado")
            return

        if args.action == "ls":
            results = hm.list_commands(limit=args.limit)
            if results:
                print(f"\n📋 Últimos comandos adicionados ({len(results)}):\n")
                print_timestamped_commands(results)
            else:
                print("✗ Banco vazio")
            return

        if args.action == "last":
            limit = args.limit if args.limit != 50 else 12
            results = hm.list_commands(limit=limit)
            if results:
                print(f"\n📋 Últimas {len(results)} entradas:\n")
                print_commands(cmd for _, cmd in results)
            else:
                print("✗ Banco vazio")
            return

        if args.action == "stats":
            hm.stats()
            return

        if args.action == "export":
            if not args.args:
                print("✗ Erro: especifique o arquivo de saída")
                sys.exit(1)
            hm.export(args.args[0])
            return

        if args.action == "delete":
            if not args.args:
                print("✗ Erro: especifique o padrão a deletar")
                sys.exit(1)
            hm.delete_pattern(" ".join(args.args))
            return

        if args.action == "clear":
            response = input(
                "⚠️  ATENÇÃO: Isso removerá TODOS os comandos. Confirma? (sim/não): ")
            if response.lower() in {"sim", "s", "yes", "y"}:
                hm.clear_all()
                print("✓ Todos os comandos foram removidos")
            else:
                print("✗ Operação cancelada")


if __name__ == "__main__":
    main()
