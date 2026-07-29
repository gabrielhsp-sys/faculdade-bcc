#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'
umask 077

readonly SERVICO_NOME="postgres-dce534"
readonly POSTGRES_IMAGE="postgres:18"
readonly POSTGRES_USUARIO="faculdade"
readonly POSTGRES_BANCO="dce534"
readonly POSTGRES_PORTA="5432"

readonly SERVICO_DIR="$HOME/servicos/$SERVICO_NOME"
readonly SECRETS_DIR="$SERVICO_DIR/secrets"
readonly SENHA_ARQUIVO="$SECRETS_DIR/postgres_password.txt"
readonly COMPOSE_ARQUIVO="$SERVICO_DIR/compose.yaml"

readonly LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/faculdade-bcc"

LOG_ARQUIVO="$LOG_DIR/setup-postgres-dce534-$(date +%Y-%m-%d_%H-%M-%S).log"
readonly LOG_ARQUIVO

mkdir -p "$LOG_DIR"

exec > >(tee -a "$LOG_ARQUIVO") 2>&1

erro() {
    printf 'ERRO: %s\n' "$*" >&2
}

aviso() {
    printf 'AVISO: %s\n' "$*" >&2
}

informar() {
    printf '\n=== %s ===\n' "$*"
}

ao_falhar() {
    local codigo="$1"
    local linha="$2"
    local comando="$3"

    erro "falha na linha ${linha}: ${comando}"
    erro "código de saída: ${codigo}"
    erro "consulte o log: ${LOG_ARQUIVO}"

    exit "$codigo"
}

trap 'ao_falhar "$?" "$LINENO" "$BASH_COMMAND"' ERR

if [[ $EUID -eq 0 ]]; then
    erro "não execute este script como root."
    erro "execute com seu usuário normal do Ubuntu."
    exit 1
fi

informar "Configuração"

printf 'Serviço: %s\n' "$SERVICO_NOME"
printf 'Imagem: %s\n' "$POSTGRES_IMAGE"
printf 'Usuário: %s\n' "$POSTGRES_USUARIO"
printf 'Banco: %s\n' "$POSTGRES_BANCO"
printf 'Endereço: 127.0.0.1:%s\n' "$POSTGRES_PORTA"
printf 'Diretório: %s\n' "$SERVICO_DIR"
printf 'Log: %s\n' "$LOG_ARQUIVO"

informar "Verificação do Docker"

if ! command -v docker >/dev/null 2>&1; then
    erro "o comando docker não está disponível no Ubuntu."
    erro "ative a integração do Ubuntu no Docker Desktop."
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    erro "o Docker Compose não está disponível."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    erro "o Docker Engine não está respondendo."
    erro "inicie o Docker Desktop no Windows e tente novamente."
    exit 1
fi

printf 'Docker Engine: OK\n'
printf 'Docker Compose: OK\n'

informar "Diretórios do serviço"

mkdir -p \
    "$SERVICO_DIR" \
    "$SECRETS_DIR"

chmod 700 \
    "$SERVICO_DIR" \
    "$SECRETS_DIR"

printf 'Diretórios criados ou validados.\n'

criar_senha() {
    local senha1=""
    local senha2=""

    while true; do
        read \
            -r \
            -s \
            -p "Defina a senha do usuário PostgreSQL: " \
            senha1

        printf '\n'

        read \
            -r \
            -s \
            -p "Repita a senha: " \
            senha2

        printf '\n'

        if [[ "$senha1" != "$senha2" ]]; then
            aviso "as senhas não coincidem."
            continue
        fi

        if (( ${#senha1} < 12 )); then
            aviso "use uma senha com pelo menos 12 caracteres."
            continue
        fi

        if [[ "$senha1" == *$'\n'* || "$senha1" == *$'\r'* ]]; then
            aviso "a senha não pode conter quebra de linha."
            continue
        fi

        printf '%s' "$senha1" > "$SENHA_ARQUIVO"
        chmod 600 "$SENHA_ARQUIVO"

        unset senha1 senha2
        break
    done
}

informar "Senha do PostgreSQL"

if [[ -s "$SENHA_ARQUIVO" ]]; then
    chmod 600 "$SENHA_ARQUIVO"

    printf 'Arquivo de senha existente preservado.\n'
    printf 'A senha não será exibida nem alterada.\n'
else
    criar_senha
    printf 'Arquivo de senha criado com permissão 600.\n'
fi

informar "Docker Compose"

cat > "$COMPOSE_ARQUIVO" <<COMPOSE
services:
  postgres:
    image: ${POSTGRES_IMAGE}
    container_name: ${SERVICO_NOME}

    environment:
      POSTGRES_USER: ${POSTGRES_USUARIO}
      POSTGRES_DB: ${POSTGRES_BANCO}
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password

    ports:
      - "127.0.0.1:${POSTGRES_PORTA}:5432"

    volumes:
      - postgres-dce534-data:/var/lib/postgresql

    secrets:
      - postgres_password

    healthcheck:
      test:
        - CMD-SHELL
        - pg_isready -U ${POSTGRES_USUARIO} -d ${POSTGRES_BANCO}
      interval: 5s
      timeout: 5s
      retries: 20
      start_period: 10s

secrets:
  postgres_password:
    file: ./secrets/postgres_password.txt

volumes:
  postgres-dce534-data:
    name: postgres-dce534-data
COMPOSE

chmod 600 "$COMPOSE_ARQUIVO"

printf 'Arquivo criado: %s\n' "$COMPOSE_ARQUIVO"

COMPOSE=(
    docker
    compose
    --project-directory "$SERVICO_DIR"
    --file "$COMPOSE_ARQUIVO"
)

"${COMPOSE[@]}" config >/dev/null

printf 'Configuração do Compose: OK\n'

informar "Inicialização do PostgreSQL"

"${COMPOSE[@]}" up -d

informar "Verificação de saúde"

POSTGRES_SAUDAVEL=false

for tentativa in $(seq 1 60); do
    estado="$(
        docker inspect \
            --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' \
            "$SERVICO_NOME" \
            2>/dev/null ||
            true
    )"

    printf 'Tentativa %02d/60: %s\n' \
        "$tentativa" \
        "${estado:-não iniciado}"

    if [[ "$estado" == "healthy" ]]; then
        POSTGRES_SAUDAVEL=true
        break
    fi

    if [[ "$estado" == "unhealthy" ]]; then
        aviso "o contêiner foi marcado como não saudável."
        "${COMPOSE[@]}" logs --tail 50 postgres || true
        break
    fi

    sleep 2
done

if [[ "$POSTGRES_SAUDAVEL" != true ]]; then
    erro "o PostgreSQL não ficou saudável no tempo esperado."
    "${COMPOSE[@]}" logs --tail 100 postgres || true
    exit 1
fi

printf 'PostgreSQL saudável: OK\n'

informar "Estrutura acadêmica inicial"

"${COMPOSE[@]}" exec -T postgres \
    psql \
        --set ON_ERROR_STOP=1 \
        --username "$POSTGRES_USUARIO" \
        --dbname "$POSTGRES_BANCO" <<'SQL'
CREATE SCHEMA IF NOT EXISTS aula
    AUTHORIZATION faculdade;

CREATE TABLE IF NOT EXISTS aula.aluno (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    matricula VARCHAR(30) UNIQUE,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON SCHEMA aula IS
    'Schema acadêmico da disciplina Banco de Dados';

COMMENT ON TABLE aula.aluno IS
    'Tabela inicial para testes e exercícios';
SQL

printf 'Schema e tabela inicial: OK\n'

informar "Validação"

"${COMPOSE[@]}" exec -T postgres \
    psql \
        --set ON_ERROR_STOP=1 \
        --username "$POSTGRES_USUARIO" \
        --dbname "$POSTGRES_BANCO" \
        --command "
            SELECT
                current_database() AS banco,
                current_user AS usuario,
                current_setting('server_version') AS versao;
        "

"${COMPOSE[@]}" exec -T postgres \
    psql \
        --set ON_ERROR_STOP=1 \
        --username "$POSTGRES_USUARIO" \
        --dbname "$POSTGRES_BANCO" \
        --command "
            SELECT
                schemaname AS schema,
                tablename AS tabela
            FROM pg_tables
            WHERE schemaname = 'aula'
            ORDER BY tablename;
        "

informar "Status do serviço"

"${COMPOSE[@]}" ps

informar "Conexão pelo DBeaver"

cat <<PASSOS
Host: 127.0.0.1
Porta: ${POSTGRES_PORTA}
Banco: ${POSTGRES_BANCO}
Usuário: ${POSTGRES_USUARIO}
Senha: conteúdo protegido de:
${SENHA_ARQUIVO}

Comandos úteis:

Iniciar:
  cd "${SERVICO_DIR}"
  docker compose up -d

Parar:
  cd "${SERVICO_DIR}"
  docker compose stop

Ver status:
  cd "${SERVICO_DIR}"
  docker compose ps

Ver logs:
  cd "${SERVICO_DIR}"
  docker compose logs -f postgres

Não use "docker compose down -v", pois "-v" remove o volume
e pode apagar permanentemente o banco de dados.
PASSOS

printf '\nPostgreSQL acadêmico configurado com sucesso.\n'
printf 'Log salvo em: %s\n' "$LOG_ARQUIVO"
