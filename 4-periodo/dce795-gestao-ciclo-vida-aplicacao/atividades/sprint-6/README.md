# Sprint 6 — Revisão de Orientação a Objetos

Atividade da disciplina **DCE795 — Gestão do Ciclo de Vida da Aplicação**.

## Conteúdo praticado

- Encapsulamento
- Construtores
- Interface
- Composição
- Herança
- Sobrescrita de métodos
- Polimorfismo
- Princípio Aberto/Fechado (OCP)
- Princípio de Substituição de Liskov (LSP)

## Como executar

```bash
javac Atividade_POO_Problema.java
java Atividade_POO_Problema
```

## Reflexões da atividade

### Por que não criar setters na classe `Console`?

Porque os dados são definidos no momento em que o objeto é criado e não precisam ficar sendo alterados livremente depois. Isso ajuda a proteger o estado do objeto e evita valores inválidos.

### Por que usar `DadosConsole`?

`Nintendo`, `Playstation` e `Xbox` têm dados em comum, como nome e preço base. A classe `DadosConsole` concentra esses dados e evita repetir os mesmos atributos e getters em todas as classes. Assim, cada console fica mais focado no comportamento que realmente muda, como ligar e calcular o preço.

### Sobrescrever dois métodos em `PlaystationPortatil` viola o LSP?

Não. A classe continua cumprindo o contrato da classe `Playstation`: ela ainda consegue ligar e calcular seu preço. O que muda é somente a forma como esses comportamentos são executados. Seria diferente de sobrescrever um método apenas para lançar `UnsupportedOperationException`, pois nesse caso a subclasse estaria recusando um comportamento que a classe pai prometia oferecer.

### O que precisou mudar em `Loja` para o Xbox funcionar?

Nada. O `Xbox` implementa `IConsole`, então a classe `Loja` consegue tratá-lo da mesma forma que os outros consoles. Isso mostra o Princípio Aberto/Fechado (OCP): o sistema pode ser estendido com novos tipos de console sem precisar modificar a lógica já existente em `Loja`.
