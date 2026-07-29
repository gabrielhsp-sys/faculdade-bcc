# Reinstalação do ambiente acadêmico

Este documento registra a ordem recomendada para reconstruir o ambiente
acadêmico usado no Windows 11 e no Ubuntu 24.04 pelo WSL 2.

## Requisitos

- Windows 11 atualizado.
- PowerShell 7.
- WinGet.
- WSL 2 com Ubuntu 24.04.
- Docker Desktop com integração ao WSL.
- Acesso administrativo no Windows.
- Usuário Linux com permissão para usar `sudo`.

## Ordem de instalação

### 1. Programas principais do Windows

Abra o PowerShell 7 como administrador e execute:

    Set-ExecutionPolicy -Scope Process Bypass
    .\scripts\setup-windows.ps1

Esse script instala os programas acadêmicos principais e as extensões do
Visual Studio Code.

### 2. Ambiente Linux do WSL

Dentro do Ubuntu, execute:

    cd ~/dev/faculdade-bcc
    chmod +x scripts/setup-wsl.sh
    ./scripts/setup-wsl.sh

Esse script instala compiladores, depuradores, Java, Maven, Flex, Bison,
Graphviz, Node.js, npm, Corepack, pnpm e outros utilitários acadêmicos.

### 3. Ferramentas auxiliares do Windows

Abra novamente o PowerShell 7 como administrador:

    Set-ExecutionPolicy -Scope Process Bypass
    .\scripts\setup-windows-auxiliares.ps1

Esse script configura:

- Apache Maven no Windows;
- vcpkg;
- JFLAP 7.1.

### 4. PostgreSQL acadêmico

Inicie o Docker Desktop e confirme que a integração com o Ubuntu está ativa.

Dentro do Ubuntu:

    cd ~/dev/faculdade-bcc
    chmod +x scripts/setup-postgres-dce534.sh
    ./scripts/setup-postgres-dce534.sh

O serviço será criado em:

    ~/servicos/postgres-dce534

Configuração padrão:

- Host: `127.0.0.1`
- Porta: `5432`
- Banco: `dce534`
- Usuário: `faculdade`

A senha fica em um arquivo protegido fora do repositório.

## Configurações manuais

Os scripts não restauram automaticamente:

- chaves SSH;
- autenticação do GitHub;
- tokens;
- senhas;
- dados pessoais;
- materiais privados das disciplinas;
- configurações específicas de drivers.

Esses elementos devem ser recriados ou restaurados de forma segura.

## Segurança

Nunca envie ao GitHub:

- chaves SSH privadas;
- arquivos `.env`;
- tokens;
- senhas;
- arquivos da pasta `secrets`;
- bancos contendo dados pessoais.

## Documentação dos scripts

Consulte:

[Scripts do ambiente acadêmico](../scripts/README.md)
