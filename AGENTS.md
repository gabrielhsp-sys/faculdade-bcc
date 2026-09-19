# AGENTS.md

## Escopo
Este é um repositório acadêmico com várias disciplinas, não um único produto implantável.
As pastas de primeiro nível `1-periodo/` … `8-periodo/` agrupam as disciplinas; cada uma pode conter aulas, atividades, trabalhos e documentos oficiais.

## Antes de editar
1. Leia `README.md` na raiz para localizar a disciplina correta.
2. Leia o README da disciplina/atividade, se houver.
3. Verifique o enunciado e as restrições locais antes de assumir versão de linguagem, arquitetura ou ferramenta.
4. Faça a menor mudança necessária e mantenha o estilo já usado naquele diretório.

## Áreas ativas
O semestre corrente está concentrado em `4-periodo/`:
- `dce131-sistemas-operacionais/`
- `dce21-estatistica-basica/`
- `dce533-computacao-grafica/`
- `dce534-banco-de-dados/`
- `dce674-teoria-linguagens-e-compiladores/`
- `dce701-programacao-web/`
- `dce795-gestao-ciclo-vida-aplicacao/`
- `dch1474-filosofia-e-metodologia-da-ciencia/`

Não existe um build/test global para o repositório. Execute comandos dentro do projeto ou atividade correspondente.

## Convenções
- Preserve códigos de disciplina e nomes de pastas.
- C/C++: warnings ativados; binários devem ir para `build/` ou `bin/`.
- Java: respeite a versão e a estrutura definidas pelo projeto local.
- Python/Node: use o ambiente e o gerenciador já presentes no diretório.
- Commits seguem Conventional Commits.
- Não versionar dependências, caches, artefatos de build, credenciais, bancos locais ou dados pessoais.

## Materiais acadêmicos
- `programa-de-ensino/` e documentos oficiais devem ser tratados como referência, não reescritos automaticamente.
- Não apague evidências, relatórios, enunciados ou arquivos de entrega sem verificar o contexto.
- Materiais de terceiros podem ter direitos próprios; não assuma que a licença MIT da raiz se aplica a eles.

## Revisão antes de entregar
Use a skill `.claude/skills/revisar-trabalho/SKILL.md` quando aplicável: compilar, rodar testes, procurar TODOs, revisar README e conferir `git status`.
