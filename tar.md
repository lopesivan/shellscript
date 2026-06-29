**Não, não está certo.** O comando tem dois problemas graves (um que faz ele falhar e outro de lógica) e uma má prática de programação.

Vamos corrigir:

### 1. O erro fatal: `tar` não lê a lista do `stdin`
O comando `ls | grep ... | tar cvzf repo.tgz` envia a lista de arquivos para o `stdin` do `tar`, mas **o `tar` não lê nomes de arquivo do `stdin` por padrão**. Ele espera os nomes como argumentos na linha de comando.

Se você rodar isso, o `tar` vai ignorar o pipe e tentar criar um arquivo vazio, resultando no erro:
`tar: Cowardly refusing to create an empty archive`

**Para corrigir isso**, você precisa adicionar a opção `-T -` (que significa "ler a lista de arquivos do stdin"):
```bash
ls | grep -v repos/ | tar cvzf repo.tgz -T -
```

---

### 2. O erro de lógica: `grep -v repos/`
O comando `ls` **não** exibe a barra (`/`) no final dos nomes de diretório (a menos que você use a flag `-p` ou `-F`). 
Portanto, se o seu diretório se chama `repos`, o `grep -v repos/` **não vai excluí-lo**, porque ele está procurando pela string `repos/` e o `ls` só mandou `repos`. 

**Para corrigir isso**, use a flag `-p` no `ls` para incluir as barras ou ajuste o grep:
```bash
ls -p | grep -v repos/ | tar cvzf repo.tgz -T -
```

---

### 3. A má prática: Parsear a saída do `ls`
Nunca use `ls` em scripts. Se algum arquivo tiver **espaços** ou **caracteres especiais** no nome, o comando vai quebrar (o tar vai interpretar o nome pela metade).

---

### ✅ A maneira **correta e mais segura** de fazer isso

Se você quer compactar **tudo** no diretório atual, **exceto** a pasta `repos/`, use o próprio recurso de exclusão do `tar`:

```bash
tar cvzf repo.tgz --exclude=repos *
```

**Explicação:** O `*` expande todos os arquivos e pastas, e o `--exclude=repos` remove a pasta especificada. Isso é seguro com espaços e muito mais simples.

*(Se você quiser compactar também os arquivos ocultos, como `.gitignore`, adicione um `.*` ao final: `tar cvzf repo.tgz --exclude=repos * .*`)*

