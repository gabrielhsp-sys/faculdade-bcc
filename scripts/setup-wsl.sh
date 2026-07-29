#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

readonly NVM_VERSION="0.40.6"
readonly NODE_VERSION="24.18.0"
readonly PNPM_VERSION="11.17.0"

readonly LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/faculdade-bcc"

LOG_FILE="${LOG_DIR}/setup-wsl-$(date +%Y-%m-%d_%H-%M-%S).log"
readonly LOG_FILE

mkdir -p "$LOG_DIR"

exec > >(tee -a "$LOG_FILE") 2>&1

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

    exit "$codigo"
}

trap 'ao_falhar "$?" "$LINENO" "$BASH_COMMAND"' ERR

if [[ $EUID -eq 0 ]]; then
    erro "não execute este script diretamente como root."
    erro "execute como usuário normal; o sudo será usado quando necessário."
    exit 1
fi

if [[ ! -r /etc/os-release ]]; then
    erro "não foi possível identificar a distribuição Linux."
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release

informar "Sistema"

printf 'Distribuição: %s\n' "${PRETTY_NAME:-desconhecida}"
printf 'Usuário: %s\n' "$(id -un)"
printf 'Home: %s\n' "$HOME"
printf 'Kernel: %s\n' "$(uname -r)"
printf 'Log: %s\n' "$LOG_FILE"

if [[ "${ID:-}" != "ubuntu" ]]; then
    aviso "este script foi preparado para Ubuntu 24.04."
fi

if [[ "${VERSION_ID:-}" != "24.04" ]]; then
    aviso "versão detectada: ${VERSION_ID:-desconhecida}."
    aviso "alguns nomes de pacotes podem ser diferentes."
fi

if ! command -v sudo >/dev/null 2>&1; then
    erro "sudo não está instalado."
    exit 1
fi

informar "Autenticação administrativa"

sudo -v

informar "Atualização dos índices APT"

sudo apt-get update

PACOTES_OBRIGATORIOS=(
    build-essential
    clang
    cmake
    ninja-build
    gdb
    valgrind
    flex
    bison
    libfl-dev
    graphviz
    openjdk-21-jdk
    maven
    git
    curl
    wget
    ca-certificates
    gnupg
    unzip
    zip
    p7zip-full
    jq
    tree
    shellcheck
    dos2unix
    keychain
    python3
    python3-pip
    python3-venv
    python-is-python3
    pkg-config
    autoconf
    automake
    libtool
    strace
    ltrace
    man-db
    manpages-dev
    rsync
)

informar "Pacotes acadêmicos obrigatórios"

sudo env DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    "${PACOTES_OBRIGATORIOS[@]}"

PACOTES_OPCIONAIS=(
    gh
    mesa-utils
    libgl1-mesa-dev
    libglfw3-dev
    libglew-dev
    libglm-dev
    freeglut3-dev
)

informar "Pacotes acadêmicos opcionais"

for pacote in "${PACOTES_OPCIONAIS[@]}"; do
    if apt-cache show "$pacote" >/dev/null 2>&1; then
        printf 'Instalando pacote opcional: %s\n' "$pacote"

        sudo env DEBIAN_FRONTEND=noninteractive \
            apt-get install -y \
            "$pacote"
    else
        aviso "pacote opcional indisponível: $pacote"
    fi
done

informar "Diretórios de trabalho"

mkdir -p \
    "$HOME/dev" \
    "$HOME/scripts" \
    "$HOME/tmp" \
    "$HOME/servicos" \
    "$HOME/.local/bin"

printf 'Diretórios acadêmicos criados ou validados.\n'

informar "Configurações gerais do Git"

git config --global core.autocrlf input
git config --global core.eol lf
git config --global core.safecrlf warn
git config --global init.defaultBranch main
git config --global pull.ff only
git config --global fetch.prune true

printf 'Configurações gerais do Git aplicadas.\n'
printf 'Nome, e-mail, assinatura e chaves SSH não foram alterados.\n'

informar "Aliases acadêmicos"

touch "$HOME/.bash_aliases"

if ! grep -Fq \
    "# >>> faculdade-bcc aliases >>>" \
    "$HOME/.bash_aliases"
then
    cat >> "$HOME/.bash_aliases" <<'ALIASES'

# >>> faculdade-bcc aliases >>>
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias cdev='cd ~/dev'
alias cfac='cd ~/dev/faculdade-bcc'
alias cservicos='cd ~/servicos'
alias gstatus='git status --short --branch'
alias glog='git log --oneline --decorate --graph -15'
# <<< faculdade-bcc aliases <<<
ALIASES

    printf 'Aliases acadêmicos adicionados.\n'
else
    printf 'Aliases acadêmicos já estavam configurados.\n'
fi

informar "NVM"

export NVM_DIR="$HOME/.nvm"

nvm_atual=""

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck disable=SC1091
    source "$NVM_DIR/nvm.sh"
    nvm_atual="$(nvm --version 2>/dev/null || true)"
fi

if [[ "$nvm_atual" != "$NVM_VERSION" ]]; then
    instalador_nvm="$(mktemp)"

    curl \
        --fail \
        --silent \
        --show-error \
        --location \
        "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" \
        --output "$instalador_nvm"

    PROFILE=/dev/null \
        NVM_DIR="$NVM_DIR" \
        bash "$instalador_nvm"

    rm -f "$instalador_nvm"
fi

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    erro "o NVM não foi instalado corretamente."
    exit 1
fi

# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"

printf 'NVM instalado: %s\n' "$(nvm --version)"

informar "Carregamento automático do NVM"

# A expressão abaixo deve ser procurada literalmente no arquivo.
# shellcheck disable=SC2016
if ! grep -Fq \
    'export NVM_DIR="$HOME/.nvm"' \
    "$HOME/.bashrc"
then
    cat >> "$HOME/.bashrc" <<'NVMRC'

# >>> faculdade-bcc nvm >>>
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] &&
    . "$NVM_DIR/nvm.sh"

[ -s "$NVM_DIR/bash_completion" ] &&
    . "$NVM_DIR/bash_completion"
# <<< faculdade-bcc nvm <<<
NVMRC

    printf 'Carregamento do NVM adicionado ao .bashrc.\n'
else
    printf 'O NVM já era carregado pelo .bashrc.\n'
fi

informar "Node.js"

nvm install "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
nvm use --silent "$NODE_VERSION"

printf 'Node.js ativo: %s\n' "$(node --version)"
printf 'npm ativo: %s\n' "$(npm --version)"

informar "Corepack e pnpm"

corepack enable

corepack prepare \
    "pnpm@${PNPM_VERSION}" \
    --activate

printf 'Corepack: %s\n' "$(corepack --version)"
printf 'pnpm global: %s\n' "$(
    cd "$HOME"
    pnpm --version
)"

informar "Verificação das ferramentas"

printf 'Git: %s\n' "$(git --version)"
printf 'GCC: %s\n' "$(gcc --version | sed -n '1p')"
printf 'G++: %s\n' "$(g++ --version | sed -n '1p')"
printf 'Clang: %s\n' "$(clang --version | sed -n '1p')"
printf 'CMake: %s\n' "$(cmake --version | sed -n '1p')"
printf 'Ninja: %s\n' "$(ninja --version)"
printf 'GDB: %s\n' "$(gdb --version | sed -n '1p')"
printf 'Valgrind: %s\n' "$(valgrind --version)"
printf 'Flex: %s\n' "$(flex --version)"
printf 'Bison: %s\n' "$(bison --version | sed -n '1p')"
printf 'Graphviz: %s\n' "$(dot -V 2>&1)"
printf 'Java: %s\n' "$(java -version 2>&1 | sed -n '1p')"
printf 'Javac: %s\n' "$(javac -version 2>&1)"
printf 'Maven: %s\n' "$(mvn -version 2>&1 | sed -n '1p')"
printf 'Python: %s\n' "$(python3 --version)"
printf 'ShellCheck: %s\n' "$(shellcheck --version | sed -n '2p')"
printf 'NVM: %s\n' "$(nvm --version)"
printf 'Node: %s\n' "$(node --version)"
printf 'npm: %s\n' "$(npm --version)"
printf 'Corepack: %s\n' "$(corepack --version)"
printf 'pnpm: %s\n' "$(
    cd "$HOME"
    pnpm --version
)"

informar "Docker Desktop"

if command -v docker >/dev/null 2>&1; then
    docker --version || true
    docker compose version || true
else
    aviso "comando Docker ainda não está disponível no WSL."
    aviso "ative a integração do Ubuntu no Docker Desktop."
fi

informar "Próximas ações manuais"

cat <<'PASSOS'
1. Recriar a chave SSH do WSL.
2. Adicionar a chave pública à conta do GitHub.
3. Configurar user.name e user.email do Git.
4. Configurar a assinatura SSH dos commits.
5. Executar gh auth login, caso o GitHub CLI esteja instalado.
6. Ativar a integração Ubuntu-24.04 no Docker Desktop.
7. Clonar o repositório faculdade-bcc em ~/dev.
8. Criar novamente os arquivos secretos do PostgreSQL.
PASSOS

printf '\nAmbiente WSL configurado com sucesso.\n'
printf 'Log salvo em: %s\n' "$LOG_FILE"
