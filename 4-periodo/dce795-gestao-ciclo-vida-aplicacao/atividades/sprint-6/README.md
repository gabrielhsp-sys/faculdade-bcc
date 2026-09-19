# Sprint 6 - Revisão de POO

Atividade da matéria de Gestão do Ciclo de Vida da Aplicação.

O código foi feito seguindo as 5 partes do roteiro: encapsulamento, construtores, interface e composição, herança e polimorfismo.

## Executar

```bash
javac Atividade_POO_Problema.java
java Atividade_POO_Problema
```

## Reflexões

### Por que não usei setters em Console?

Porque os valores são passados no construtor e depois só precisam ser lidos. Assim os atributos não ficam sendo alterados de qualquer lugar.

### Por que usar DadosConsole?

Nintendo e Playstation têm os mesmos dados básicos, que são nome e preço. Então usei a classe DadosConsole para guardar isso e não precisar repetir os mesmos atributos nas duas classes.

### Sobrescrever os métodos de PlaystationPortatil é um problema?

Não, porque ela continua fazendo o que a classe Playstation promete. Ela só muda a forma de ligar e o cálculo do preço. Seria diferente se um método fosse sobrescrito só para lançar uma exceção e não fazer o que deveria.

### O que mudou em Loja para o Xbox funcionar?

Nada. Como Xbox também implementa IConsole, a Loja consegue usar ele igual aos outros consoles. Isso mostra o OCP, porque dá para adicionar um novo tipo sem precisar alterar a Loja.
