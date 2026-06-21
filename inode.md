```bash
# descobre o inode
ls -i arquivo.txt
# ex: 123456 arquivo.txt

# acessa pelo inode
find / -inum 123456

# lê o conteúdo
find /caminho -inum 123456 -exec cat {} \;
```

No Linux não tem como abrir um arquivo direto pelo inode em userspace — o `find` é o caminho. O inode é um conceito do kernel; o VFS exige um path para `open()`.

Se precisares acessar por inode sem path (ex: inode órfão), aí é via `debugfs`:

```bash
sudo debugfs /dev/sda1
debugfs> cat <123456>
```

O `<123456>` é a sintaxe do `debugfs` para referenciar por inode direto.


Se o processo ainda tem o arquivo aberto, consegues recuperar via `/proc`:

```bash
# descobre o pid que tem o arquivo aberto
lsof | grep "nome-do-arquivo"

# lê pelo file descriptor
cat /proc/<PID>/fd/<FD>

# copia de volta
cp /proc/<PID>/fd/<FD> recuperado.txt
```

Se ninguém tem aberto, aí só via `debugfs`:

```bash
sudo debugfs /dev/sda1

# lê o conteúdo
debugfs> cat <123456>

# copia para fora
debugfs> dump <123456> /tmp/recuperado.txt
```

**Importante:** após deletar, para de escrever no filesystem imediatamente — o kernel pode realocar os blocos do inode a qualquer momento. Quanto mais rápido agires, maior a chance de recuperação.

Se não souberes o inode, ferramentas como `extundelete` ou `testdisk` escaneiam a journal do ext4 para encontrar inodes deletados recentemente:

```bash
sudo extundelete /dev/sda1 --restore-all
```

