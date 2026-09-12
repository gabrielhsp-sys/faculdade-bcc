# Sprint 4 - Princípios de Projeto

**Aluno:** Gabriel Henrique  
**Período:** 03/09 a 10/09/2026  
**Atividade prática:** refatoração do sistema de pedidos em Java

## 1. Resumo do estudo

Projeto de software é a atividade de decompor um problema complexo em partes menores,
independentes e fáceis de usar por meio de abstrações. Um bom projeto busca reduzir a
complexidade do sistema e facilitar entendimento, testes, manutenção e evolução.

### Propriedades importantes

- **Integridade conceitual:** o sistema deve seguir ideias, nomes e padrões coerentes.
- **Ocultamento de informação:** detalhes sujeitos a mudança devem ficar escondidos atrás
  de interfaces estáveis.
- **Coesão:** elementos de uma classe devem colaborar para uma responsabilidade bem definida.
- **Acoplamento:** dependências entre classes são aceitáveis quando passam por interfaces
  públicas e estáveis; tornam-se ruins quando mudanças internas se propagam pelo sistema.

### Princípios estudados

| Princípio | Ideia central | Aplicação no projeto |
|---|---|---|
| SRP | Uma classe deve ter um motivo principal para mudar | Persistência saiu de `PedidoService` |
| ISP | Interfaces devem ser pequenas e específicas | `IPagamento` foi dividida em três interfaces |
| DIP | Código de alto nível deve depender de abstrações | Serviço recebe repositório, desconto e pagamento |
| Composição | Reutilizar objetos quando não existe relação “é um” | Serviço não herda mais de cartão |
| Lei de Demeter | Um objeto deve conhecer poucos detalhes dos demais | Cadeia de getters foi escondida pelo domínio |
| OCP | Estender comportamentos sem alterar código estável | Descontos e pagamentos usam polimorfismo |
| LSP | Subtipos devem respeitar o contrato da abstração | Entregas expõem disponibilidade e cálculo de frete |

### Métricas

- **LOC:** quantidade de linhas de código, desde que o critério de contagem seja informado.
- **LCOM1:** conta pares de métodos que não acessam atributos em comum. Quanto maior, menor
  tende a ser a coesão.
- **CBO:** conta quantas classes aparecem como dependências estruturais de uma classe.
- **Complexidade ciclomática (CC):** número de decisões de um método mais 1. O menor valor é 1.

Fonte de estudo: [Capítulo 5 - Princípios de Projeto](https://engsoftmoderna.info/cap5.html).

## 2. Exercícios de fixação

### 1. Três benefícios do ocultamento de informação

1. Permite **desenvolvimento paralelo**, pois cada equipe trabalha nos detalhes internos do
   seu módulo sem precisar conhecer todo o sistema.
2. Dá **flexibilidade para mudanças**, porque uma implementação pode ser substituída sem
   alterar os clientes que usam sua interface.
3. Melhora a **facilidade de entendimento**, já que o desenvolvedor precisa conhecer somente
   a interface pública e estável da classe.

### 2. Mover para o mesmo arquivo classes alteradas juntas

A estratégia melhora a **coesão no nível do arquivo**, pois coloca próximos elementos que
costumam participar da mesma alteração. Também torna visível um acoplamento evolutivo que já
existia entre A e B.

Por outro lado, se aplicada mecanicamente, ela prejudica a **modularidade e o ocultamento de
informação**: classes com responsabilidades distintas passam a compartilhar a mesma unidade,
ficam mais difíceis de desenvolver separadamente e o arquivo tende a crescer indefinidamente.
Ela também não elimina o acoplamento real entre as classes; apenas muda sua localização.

### 3. Problema da *classitis*

Dividir exageradamente o sistema pode produzir classes individualmente pequenas e coesas,
mas aumentar o acoplamento total. Uma tarefa simples passa a exigir navegação e chamadas entre
muitos objetos. Portanto, a coesão local melhora, porém a compreensão do comportamento global,
a manutenção e os testes ficam mais difíceis. O objetivo não é maximizar a quantidade de
classes, mas encontrar uma decomposição que equilibre coesão e acoplamento.

### 4. Definições de acoplamento

- **Aceitável:** A usa a interface pública e estável de B. Mudanças internas em B não afetam A.
- **Ruim:** A depende de detalhes instáveis de B; alterações internas em B podem obrigar A a mudar.
- **Estrutural:** existe referência sintática explícita, como atributo, parâmetro, herança ou
  criação de um objeto do tipo B no código de A.
- **Evolutivo ou lógico:** A e B tendem a mudar juntas, mesmo que A não cite B diretamente.

### 5. Exemplos de acoplamento estrutural

1. **Estrutural e aceitável:** `PedidoService` possui um campo do tipo `PedidoRepository` e usa
   seu método público `salvar`. A dependência é explícita, mas mediada por uma interface estável.
2. **Estrutural e ruim:** a versão original de `PedidoService` herda de `PagamentoCartao` sem ser
   um tipo de cartão. Mudanças no cartão podem afetar um serviço que não deveria depender dele.

### 6. Acoplamento sem referência no código

Sim. A pode ler um arquivo produzido internamente por B sem declarar nenhuma referência para B.
Se B mudar o formato, A quebra. Esse é acoplamento evolutivo e ruim, pois a dependência está
escondida e não é protegida por uma interface estável.

### 7. Todo o código dentro de `main`

O problema principal é de **coesão**: o mesmo método concentra entrada, regras de negócio,
persistência, apresentação e outras responsabilidades. Também pode haver alto acoplamento com
muitas bibliotecas e classes, mas colocar tudo em `main` caracteriza sobretudo baixa coesão.

### 8. Método `onclick` com transferência bancária

Viola o **Princípio da Responsabilidade Única**. O método de interface gráfica lê campos,
consulta o banco, controla a transação e executa a regra de transferência. A interface deveria
coletar os valores e delegar a operação a um serviço, por exemplo:

```java
void onclick() {
    transferenciaService.transferir(
        textfield1.value(),
        textfield2.value(),
        textfield3.value()
    );
}
```

### 9. Escolher somente dois entre encapsulamento, polimorfismo e herança

Eu eliminaria **herança**. Encapsulamento é essencial para ocultar informações e polimorfismo
permite variar implementações por meio de contratos. Grande parte do reúso atribuído à herança
pode ser obtida com composição e interfaces, normalmente com menos acoplamento e sem criar
hierarquias rígidas.

### 10. `sendMail` e a cadeia conta → cliente → endereço

Viola a **Lei de Demeter**, pois o método conhece a estrutura interna de `ContaBancaria` e
`Cliente`. A conta pode fornecer diretamente a informação necessária:

```java
void sendMail(ContaBancaria conta, String msg) {
    String endereco = conta.getEnderecoEmailCliente();
    // envia o e-mail
}
```

### 11. `imprimeDataContratacao` e a formatação da data

Também viola a **Lei de Demeter**: o cliente obtém `Date` e manda esse objeto se formatar. O
conhecimento pode ser escondido em `Funcionario`:

```java
void imprimeDataContratacao(Funcionario funcionario) {
    System.out.println(funcionario.getDataContratacaoFormatada());
}
```

### 12. Pré e pós-condições de `A.f` e `B.f`

O código viola o **Princípio da Substituição de Liskov**. A subclasse B fortalece a pré-condição
de `x > 0` para `x > 10`, recusando entradas aceitas por A. Além disso, enfraquece a pós-condição
de resultado positivo para resultado maior que -50. Portanto, um objeto B não pode substituir A
sem surpreender o cliente.

### 13. CBO e LCOM da classe A

As dependências estruturais distintas são `B`, `C`, `D`, `E` e `F`. Logo:

```text
CBO(A) = 5
```

Conjuntos de atributos acessados:

```text
A(m1) = {f1, f2}
A(m2) = {f2, f3}
A(m3) = {f3}
```

Entre os três pares possíveis, somente `(m1, m3)` tem interseção vazia. Assim:

```text
LCOM1(A) = 1
```

### 14. Classe mais coesa

Na primeira classe, `f`, `g` e `h` acessam o atributo `x`. Nenhum dos três pares de métodos é
disjunto, portanto `LCOM1(A) = 0`.

Na segunda, cada método acessa um atributo diferente: `f` usa `x`, `g` usa `y` e `h` usa `z`.
Os três pares são disjuntos, portanto `LCOM1(B) = 3`.

Como um LCOM menor indica menor falta de coesão, **a classe A é mais coesa**.

### 15. Por que LCOM mede ausência de coesão?

Coesão é uma propriedade positiva e abstrata, difícil de contar diretamente. LCOM usa um sinal
concreto de falta de coesão: pares de métodos que trabalham com conjuntos separados de atributos.
Quanto mais pares disjuntos, maior a evidência de responsabilidades desconectadas na classe.

### 16. Todos os métodos entram no LCOM?

Não. Na definição LCOM1 apresentada no capítulo, **construtores, getters e setters são
desconsiderados**. Construtores normalmente acessam muitos atributos, enquanto getters e
setters costumam acessar apenas um; incluí-los distorceria a avaliação dos métodos que realmente
implementam o comportamento da classe.

### 17. A CC é independente da linguagem?

Sim. Sua definição deriva do grafo de fluxo de controle e não de uma sintaxe específica. Cada
linguagem possui comandos diferentes para expressar decisões, mas `if`, laços, casos e construções
equivalentes criam caminhos alternativos que podem ser contados da mesma forma.

### 18. Código com complexidade ciclomática mínima

```java
int somar(int a, int b) {
    return a + b;
}
```

Não há comando de decisão. Portanto, `CC = 0 + 1 = 1`, que é o valor mínimo.

### 19. Versão monolítica versus versão orientada a objetos

A [versão monolítica](https://github.com/mtov/exercises-in-programming-style/blob/master/04-monolith/tf-04.py)
executa leitura, normalização, remoção de *stop words*, contagem, ordenação e saída em um único
fluxo com dados globais. Ela é curta, mas suas decisões estão misturadas: mudar a forma de
armazenamento ou testar somente a contagem exige compreender quase todo o programa.

A [versão orientada a objetos](https://github.com/mtov/exercises-in-programming-style/blob/master/11-things/tf-11.py)
separa o trabalho em `DataStorageManager`, `StopWordManager`, `WordFrequencyManager` e
`WordFrequencyController`. Cada classe encapsula seus dados e oferece operações com significado
claro. Em um sistema maior, isso permite:

- equipes diferentes trabalharem em armazenamento, filtro e contagem;
- testes unitários de cada responsabilidade;
- troca da estrutura de frequência sem alterar leitura e filtragem;
- localização mais rápida de defeitos;
- reúso de partes do processamento;
- menor risco de uma alteração se propagar pelo programa inteiro.

A solução OO introduz mais classes e algum acoplamento entre elas, mas esse acoplamento é
explícito e ocorre por interfaces pequenas. Para o exemplo minúsculo, o monólito pode parecer
mais direto; com crescimento e trabalho em equipe, a separação orientada a objetos tende a ser
mais sustentável.

## 3. Refatoração prática do projeto Java

### Etapa 1 - SRP e persistência

**Problema:** `PedidoService` calculava, salvava arquivo, apresentava resumo, selecionava
pagamento e notificava o cliente.

**Solução:** criação de `PedidoRepository` e `PedidoRepositoryArquivo`. O serviço apenas chama
`repository.salvar(pedido, total)`. A gravação com `Files.writeString` ficou isolada.

### Etapa 2 - ISP no pagamento

**Problema:** `IPagamento` obrigava PIX, cartão e boleto a implementar operações sem sentido.

**Solução:** divisão em:

```text
Pagamento  -> pagar(valor)
Parcelavel -> parcelar(valor, parcelas)
GeraBoleto -> gerarBoleto(valor)
```

O cartão implementa `Pagamento` e `Parcelavel`; o PIX implementa somente `Pagamento`; o boleto
implementa `Pagamento` e `GeraBoleto`. Foram removidos métodos vazios e exceções de operação não
suportada.

### Etapa 3 - composição no lugar de herança

**Problema:** `PedidoService extends PagamentoCartao` afirmava incorretamente que o serviço “é
um” cartão.

**Solução:** a herança foi removida. A forma de pagamento é recebida como objeto no método
`finalizarPedido`, caracterizando composição e delegação.

### Etapa 4 - Lei de Demeter

**Problema original:**

```java
pedido.getCliente().getEndereco().getCidade().getNome();
```

**Solução:** cada objeto conversa somente com seu colaborador direto:

```text
Pedido.getCidadeEntrega()
  -> Cliente.getCidadeEntrega()
     -> Endereco.getNomeCidade()
        -> Cidade.getNome()
```

O serviço usa apenas `pedido.getCidadeEntrega()`.

### Etapa 5 - OCP nos descontos

**Problema:** toda nova categoria de cliente exigia adicionar outro `if/else` no serviço.

**Solução:** a interface `Desconto` possui `calcular(subtotal)`. As classes `DescontoAluno`,
`DescontoProfessor` e `DescontoFuncionario` guardam seus percentuais. Uma nova regra exige apenas
uma nova implementação e sua escolha no ponto de configuração.

### Etapa 6 - DIP e remoção dos `if/else` de pagamento

**Problema:** o serviço recebia textos como `"CARTAO"` e criava classes concretas.

**Solução:** `finalizarPedido` recebe um `Pagamento`. A classe `Main` fornece
`new PagamentoCartao()`, mas poderia fornecer PIX, boleto ou uma implementação futura sem alterar
`PedidoService`.

### Etapa 7 - LSP nas entregas

**Problema:** `EntregaRetiradaLoja` herdava de uma classe concreta que parecia aceitar qualquer
pedido, mas lançava exceção abaixo de R$ 50,00.

**Solução:** `EntregaDomicilio` e `RetiradaLoja` implementam `TipoEntrega`. O contrato expõe
`estaDisponivel(total)` antes de `calcularFrete(total)`. Assim, a restrição de R$ 50,00 não foi
apagada e deixou de ser uma surpresa escondida na hierarquia.

## 4. Estrutura final

```text
projetoprincipiosdesign/
├── domínio: Cidade, Endereco, Cliente, ItemPedido, Pedido
├── pagamento: Pagamento, Parcelavel, GeraBoleto e implementações
├── desconto: Desconto e três implementações
├── entrega: TipoEntrega, EntregaDomicilio, RetiradaLoja
├── persistência: PedidoRepository, PedidoRepositoryArquivo
├── serviço: PedidoService
├── execução: Main
└── testes: TesteRefatoracao
```

## 5. Compilação e testes

Na pasta `ProjetoPrincipiosDesignJava`:

```bash
javac -d out src/projetoprincipiosdesign/*.java
java -cp out projetoprincipiosdesign.Main
java -cp out projetoprincipiosdesign.TesteRefatoracao
```

Validação realizada:

```text
Compilação: concluída sem erros
Saída principal: preservada
Cidade: Belo Horizonte
Total do aluno: R$ 144,00
Pagamento no cartão: R$ 144,00
Testes: 10/10 aprovados
```

## 6. Reflexões finais do roteiro

### Quais classes ficaram com responsabilidades mais claras?

`PedidoService` ficou responsável por orquestrar o fechamento do pedido;
`PedidoRepositoryArquivo` cuida somente da persistência; cada classe de desconto calcula sua
regra; cada pagamento implementa apenas suas capacidades; e cada entrega declara disponibilidade
e frete. O domínio também passou a esconder a navegação entre seus objetos.

### Quantas classes precisam mudar para adicionar um comportamento?

- **Novo pagamento:** criar uma classe que implemente `Pagamento` e selecioná-la em `Main`.
- **Novo desconto:** criar uma classe que implemente `Desconto` e selecioná-la em `Main`.
- **Novo repositório:** criar uma classe que implemente `PedidoRepository`.
- **Nova entrega:** criar uma classe que implemente `TipoEntrega`.

As classes estáveis, especialmente `PedidoService`, não precisam ser alteradas. Em termos de
código de domínio, muda somente a nova implementação; o ponto de composição (`Main`) apenas
escolhe qual objeto usar.

## Referências

- Marco Tulio Valente. [Engenharia de Software Moderna - Capítulo 5](https://engsoftmoderna.info/cap5.html).
- [Código monolítico do exercício 19](https://github.com/mtov/exercises-in-programming-style/blob/master/04-monolith/tf-04.py).
- [Código orientado a objetos do exercício 19](https://github.com/mtov/exercises-in-programming-style/blob/master/11-things/tf-11.py).
- `Roteiro completo refatoração.pdf` e `Roteiro Refatoração (Simplificado).pdf`, fornecidos para a Sprint 4.
