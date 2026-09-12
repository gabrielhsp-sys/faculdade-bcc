# Refatoração - Princípios de Projeto

Atividade da Sprint 4 da disciplina de Engenharia de Software.

O projeto representa uma loja acadêmica com pedidos, descontos, formas de
pagamento, entrega e persistência em arquivo. O código inicial foi refatorado
sem alterar o resultado esperado da aplicação.

## Princípios aplicados

- Responsabilidade Única (SRP)
- Segregação de Interfaces (ISP)
- Inversão de Dependência (DIP)
- Composição no lugar de herança
- Lei de Demeter
- Aberto/Fechado (OCP)
- Substituição de Liskov (LSP)

As explicações e respostas dos exercícios estão em
[`ENTREGA_SPRINT_4.md`](ENTREGA_SPRINT_4.md).

## Como executar

É necessário ter o JDK 17 ou superior.

```bash
javac -d out src/projetoprincipiosdesign/*.java
java -cp out projetoprincipiosdesign.Main
```

## Como testar

```bash
java -cp out projetoprincipiosdesign.TesteRefatoracao
```

Resultado esperado:

```text
Testes concluídos: 10/10.
```
