# faculdade-bcc — Contexto para Claude Code

## Sobre
Repositório da graduação em Ciência da Computação na UNIFAL-MG.
Semestre atual: 4º período, 2026/2.

## Local
No ambiente principal do Fedora, este repositório fica em:

```text
~/Dev/projects/academic/faculdade-bcc
```

## Estrutura
As disciplinas ficam agrupadas por período (`1-periodo/` … `8-periodo/`).
Cada disciplina usa, quando aplicável:

- `programa-de-ensino/` — ementa e documentos oficiais; não alterar sem necessidade;
- `aulas/` — anotações e código de aula;
- `atividades/` — listas e exercícios;
- `trabalhos/` — trabalhos e projetos avaliativos.

Antes de editar, leia o `README.md` da raiz e o README da disciplina, se existir.

## Convenções
- Preserve o enunciado e as restrições específicas de cada atividade.
- Não imponha arquitetura, biblioteca ou versão de linguagem sem verificar a disciplina.
- C/C++: compilar com warnings ativados; prefira saídas em `build/` ou `bin/`, nunca binários misturados aos fontes.
- Java: use a versão e a estrutura exigidas pela atividade; Maven quando o projeto já estiver configurado para ele.
- Commits: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`).
- Nunca commitar `node_modules/`, `target/`, `build/`, arquivos de IDE, credenciais ou dados pessoais.

## Disciplinas ativas
O trabalho corrente está principalmente em `4-periodo/`, incluindo:
- DCE131 — Sistemas Operacionais
- DCE21 — Estatística Básica
- DCE533 — Computação Gráfica
- DCE534 — Banco de Dados
- DCE674 — Teoria de Linguagens e Compiladores
- DCE701 — Programação Web
- DCE795 — Gestão do Ciclo de Vida da Aplicação
- DCH1474 — Filosofia e Metodologia da Ciência

## Regra de segurança acadêmica
Não altere material oficial de professor, enunciados ou evidências de entrega sem instrução explícita. Em trabalhos avaliativos, preserve a estrutura pedida e priorize mudanças pequenas, verificáveis e fáceis de explicar.
