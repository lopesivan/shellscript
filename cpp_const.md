
Em Rust, na linguagem Rust, você, quando declara uma variável, ela é read-only, né? Você só pode, ela não pode ser alterada. Quando ela deve ser alterada, você usa a palavra mut, né? Então, me explica como é que eu crio uma variável em C que não possa ser alterada.

Exatamente. Em Rust, variáveis são imutáveis por padrão:

let x = 10;
// x = 20;   // erro

let mut y = 10;
y = 20;      // OK

Em C, ocorre praticamente o contrário: uma variável comum é modificável por padrão. Para impedir sua alteração, usamos const:

int x = 10;
x = 20;       // OK

const int y = 10;
// y = 20;    // ERRO

Então podemos fazer esta correspondência conceitual:

Rust	C	Significado

let x = 10;	const int x = 10;	não pode alterar
let mut x = 10;	int x = 10;	pode alterar


Por exemplo, em C:

#include <stdio.h>

int main(void)
{
    const double pi = 3.14159265359;

    printf("pi = %f\n", pi);

    // pi = 3.14;   // erro de compilação

    return 0;
}

Um detalhe importante sobre const em C

Quando entrarmos em ponteiros, const fica ainda mais interessante, porque estas declarações são diferentes:

const int *p;
int *const p;
const int *const p;

Elas significam, respectivamente:

const int *p;        // não altera o valor através de p
int *const p;        // não altera o próprio ponteiro
const int *const p;  // não altera nenhum dos dois

Essa parte é especialmente útil para entender a filosofia de Rust, porque Rust leva muito mais longe a ideia de mutabilidade explícita e controle de acesso aos dados.


Claro. O ponto fundamental é separar duas coisas: o valor apontado e o próprio ponteiro.

Considere inicialmente:

int x = 10;
int y = 20;

1. const int *p — valor constante através do ponteiro

int x = 10;
int y = 20;

const int *p = &x;

printf("%d\n", *p);

// *p = 50;   // ❌ ERRO: não posso alterar x através de p

p = &y;       // ✅ OK: posso fazer p apontar para outro lugar

printf("%d\n", *p);

Aqui:

p  →  x
      10

Você não pode alterar *p, mas pode alterar p.

Uma maneira de ler:

> "p é um ponteiro para um int constante."




---

2. int *const p — ponteiro constante

Agora é o contrário:

int x = 10;
int y = 20;

int *const p = &x;

*p = 50;      // ✅ OK: posso alterar x

// p = &y;    // ❌ ERRO: p não pode apontar para outro lugar

printf("%d\n", x);

Aqui, o endereço armazenado em p ficou fixo:

p
      │
      ▼
x = 10

Podemos mudar:

*p = 50;

resultando em:

p
      │
      ▼
x = 50

Mas não podemos fazer:

p = &y;

Uma maneira de ler:

> "p é um ponteiro constante para int."




---

3. const int *const p — ambos constantes

Agora juntamos as duas restrições:

int x = 10;
int y = 20;

const int *const p = &x;

// *p = 50;   // ❌ ERRO: não posso alterar o valor
// p = &y;    // ❌ ERRO: não posso alterar o ponteiro

printf("%d\n", *p);

Nem o endereço armazenado em p nem o valor acessado através de p podem ser modificados.

Resumindo:

Declaração	*p = 50	p = &y

const int *p	❌	✅
int *const p	✅	❌
const int *const p	❌	❌


Um macete para ler essas declarações

Leia a partir do nome p:

const int *p;

p é ponteiro para const int.

int *const p;

p é constante e é ponteiro para int.

const int *const p;

p é constante e é ponteiro para const int.

E há um detalhe muito importante: no primeiro caso, const int *p, isso não significa necessariamente que x seja imutável. Significa apenas que você não pode modificar x através desse ponteiro:

int x = 10;

const int *p = &x;

// *p = 20;   // ❌
x = 20;       // ✅ perfeitamente válido

Essa distinção entre "o objeto é constante" e "eu tenho uma referência que não permite modificá-lo" é justamente onde a comparação com referências de Rust começa a ficar bem interessante.

