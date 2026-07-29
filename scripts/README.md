# Scripts do ambiente acadêmico

Scripts usados para reconstruir o ambiente acadêmico do Windows e do WSL.

## Arquivos

### `setup-windows.ps1`

Instala os programas acadêmicos principais no Windows usando o WinGet e
configura as extensões do Visual Studio Code.

Deve ser executado no PowerShell 7 como administrador.

### `setup-windows-auxiliares.ps1`

Configura ferramentas que exigem instalação complementar:

- Apache Maven no Windows;
- vcpkg;
- JFLAP 7.1.

Deve ser executado no PowerShell 7 como administrador.

### `setup-wsl.sh`

Configura o Ubuntu 24.04 no WSL 2 com:

- compiladores e depuradores;
- Java e Maven;
- Flex, Bison e Graphviz;
- Node.js, npm, Corepack e pnpm;
- ferramentas acadêmicas gerais.

Deve ser executado como usuário Linux normal, não como root.

### `setup-postgres-dce534.sh`

Cria o PostgreSQL 18 usado na disciplina Banco de Dados.

O script:

- usa Docker Compose;
- mantém a senha fora do arquivo Compose;
- restringe a porta a `127.0.0.1`;
- usa volume persistente;
- cria o banco `dce534`;
- cria o schema acadêmico inicial.

## Ordem recomendada

1. `setup-windows.ps1`
2. `setup-wsl.sh`
3. `setup-windows-auxiliares.ps1`
4. `setup-postgres-dce534.sh`

## Segurança

Os scripts não devem conter:

- senhas;
- tokens;
- chaves privadas;
- dados pessoais;
- materiais acadêmicos privados.
