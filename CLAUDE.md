# faculdade-bcc — Contexto para Claude Code

## Sobre
Repositório da graduação em Ciência da Computação, UNIFAL-MG, Gabriel Henrique.
4º período, 2026/2.

## Estrutura
Cada disciplina em `4-periodo/dceXXX-nome/` com:
- programa-de-ensino/ — ementa oficial (não editar)
- aulas/ — anotações e código de aula
- atividades/ — listas e exercícios
- trabalhos/ — trabalhos avaliativos

## Convenções
- C/C++: padrão C11, sempre compilar com -Wall -Wextra
- Java: Java 21, Maven, sigo padrão do Academic System (camadas View/Controller/Service/Repository/Model)
- Commits: seguir Conventional Commits (feat:, fix:, docs:, chore:)
- Nunca commitar node_modules, target/, build/, arquivos de IDE

## Ambiente
- WSL2 Ubuntu, Docker com pg-fac (Postgres) e mysql-fac (MySQL) rodando
- gcc 15, Node 24 LTS, Java 21 Temurin, Python 3.14

## Computação Gráfica (dce533)
- Trabalho fica em C:\Dev\cg-trabalho (Windows), não neste repo, por causa de assets pesados
- eGPU: AMD RX 580 via M.2, funciona em [HIP/OpenCL — preencher depois do teste]
