# Atividade Prática – NeoBank+ (Ciclo Completo de Desenvolvimento)

Este repositório documenta o ciclo de desenvolvimento de software para a plataforma **NeoBank+**, um banco digital inteligente focado em pagamentos instantâneos, controle financeiro e segurança avançada.

O projeto foi desenvolvido como atividade prática da disciplina de Engenharia de Software, seguindo as 6 etapas do "Tema 6: Ciclo Completo de Desenvolvimento de Software".

## 🧭 Estrutura do Projeto (Artefatos Entregáveis)

Este repositório contém o código-fonte do MVP na raiz e todos os artefatos de documentação na pasta `/docs`, conforme os "Produtos Finais Esperados".

| Etapa do Projeto | Artefato Entregável | Arquivo no Repositório |
| :--- | :--- | :--- |
| **Etapa 1:** Requisitos | Documento de Requisitos Priorizados | `./docs/Requisitos.pdf` |
| **Etapa 2:** Modelagem | Diagrama de Casos de Uso | `./docs/Diagrama de Caso de Uso.pdf` |
| **Etapa 2:** Modelagem | Diagrama de Classes (MER) | `./docs/Diagramas de Classe UML Exemplo.pdf` |
| **Etapa 2:** Modelagem | Protótipos de Interface (App Mobile) | `./docs/Design Neobank+.pdf` |
| **Etapa 3:** Implementação | MVP em Repositório (Web) | `./index.html`, `./style.css`, `./app.js` |
| **Etapa 4:** Testes | Plano de Testes com Evidências | `./docs/Testes.pdf` |
| **Etapa 5:** Qualidade | Relatório de Métricas e Riscos | *(Definido nesta documentação)* |
| **Etapa 6:** Reflexão | Reflexão Crítica | *(Definido nesta documentação)* |

---

## Etapa 1: Engenharia de Requisitos

A análise completa dos requisitos do sistema, conflitos e priorização está documentada no arquivo `docs/Requisitos.pdf`.

Este documento inclui:
* **Requisitos Funcionais:** Detalhamento de 21 requisitos funcionais, como "Abertura de conta digital (KYC)", "Alertas de transações suspeitas em tempo real" e "Gerenciamento de dispositivos conectados".
* **Requisitos Não Funcionais:** Definição de atributos de performance, segurança e conformidade, como "Escalabilidade para 5 milhões de contas ativas", "Transações < 2 segundos" e "Conformidade com BACEN, LGPD".
* **Análise de Conflitos:** Mediação de conflitos clássicos como "Usabilidade vs. Segurança" e "Rapidez vs. Conformidade".

## Etapa 2: Desenho e Modelagem

O design do sistema foi dividido em Modelagem de Dados e Prototipação de Interface, conforme solicitado.

* **Diagrama de Casos de Uso:** Detalha as interações dos atores "Cliente", "Administrador" e "Analista de Crédito" com o sistema . (Veja `docs/Diagrama de Caso de Uso.pdf`).
* **Diagrama de Classes (MER):** O modelo lógico de dados está no arquivo `docs/Diagramas de Classe UML Exemplo.pdf`. Ele define as entidades centrais do sistema, como `Usuario`, `Conta`, `Transacao` e `LogAuditoria`.
* **Protótipos de Interface (App Mobile):** O arquivo `docs/Design Neobank+.pdf` contém os protótipos de alta fidelidade para o aplicativo mobile, conforme solicitado. Este artefato visualiza o fluxo de usuário para as telas principais, incluindo:
    * Onboarding e Cadastro.
    * Login e Autenticação.
    * Dashboard (Home).
    * Gerenciamento de Cartões (Físico e Virtual).
    * Fluxo de Pagamento (Central Pix).
    * Comprovantes de Transação.
    * Notificações e Estatísticas.

## Etapa 3: Implementação (MVP)

O código-fonte na raiz deste repositório (`index.html`, `style.css`, `app.js`) constitui o MVP (Minimum Viable Product) funcional da interface web, conforme os requisitos da Etapa 3.

### Funcionalidades do MVP Implementadas

Este protótipo simula as seguintes funcionalidades essenciais:

1.  **Cadastro de Conta Digital Simples**
    * **Onde:** Página "Abrir Conta" (`#cadastro-page`).
    * **O que faz:** Um formulário (`form-cadastro`) que, ao ser enviado, exibe uma mensagem de sucesso (`#cadastro-success`) e redireciona o usuário para o Dashboard, simulando o fluxo em `app.js`.

2.  **Transferência PIX Mockada**
    * **Onde:** Página "PIX" (`#pix-page`).
    * **O que faz:** Permite o preenchimento de uma chave e valor (`form-pix`). Ao enviar, exibe uma mensagem de sucesso simulada (`#pix-success`).

3.  **Emissão de Cartão Virtual Mockado**
    * **Onde:** Página "Cartões" (`#cartoes-page`).
    * **O que faz:** Ao clicar no botão "Emitir Cartão Virtual" (`#btn-emitir-cartao`), um cartão virtual (`#cartao-virtual`) é exibido na tela.

4.  **Dashboard com Saldo e Extrato**
    * **Onde:** Página "Dashboard" (`#dashboard-page`).
    * **O que faz:** Exibe um saldo estático (`R$ 4.580,22`) e uma lista de transações recentes (`.extrato-lista`) com dados fixos.

5.  **Alerta de Transação Suspeita (Simulação)**
    * **Onde:** Página "Dashboard" (`#dashboard-page`).
    * **O que faz:** Um alerta de segurança estático (`#alerta-fraude`) é exibido no topo do dashboard, simulando o requisito funcional.

### README com Setup

#### Tecnologias Utilizadas
* **HTML5:** Estrutura semântica (`index.html`).
* **CSS3:** Estilização responsiva, Modo Escuro e Variáveis CSS (`style.css`).
* **JavaScript (ES6+):** Manipulação do DOM, navegação SPA e simulação de eventos (`app.js`).

#### Como Executar o Projeto
Como este projeto é um MVP estático (frontend puro), não há necessidade de compilação ou instalação de dependências.

1.  **Clone o repositório da faculdade:**
    ```bash
    git clone https://github.com/gabrielhsp-sys/faculdade-bcc.git
    ```

2.  **Entre na pasta do NeoBank+:**
    ```bash
    cd faculdade-bcc/2-periodo/dce527-engenharia-de-software/trabalhos/neobank
    ```

3.  **Abra o projeto:**
    * Abra o arquivo `index.html` diretamente no seu navegador de preferência.

## Etapa 4: Testes

O plano de testes e as evidências de execução estão documentados em `docs/Testes.pdf`. O documento detalha os cenários de teste para as funcionalidades exigidas, incluindo:

* **Caso 1:** Cadastro de conta válido.
* **Caso 2:** Transferência PIX bem-sucedida.
* **Caso 3:** Falha em transferência por saldo insuficiente.
* **Caso 4:** Emissão de cartão virtual.
* **Caso 5:** Registro de transação em extrato.
* **Caso 6:** Geração de relatório PDF.
* **Caso 7:** Alerta de fraude simulado.
* **Caso 8:** Teste de carga (100k transações).
* **Caso 9:** Teste de segurança (Injeção SQL).

## Etapa 5: Qualidade e Riscos

Esta seção define o "Relatório de Métricas e Riscos", conforme solicitado.

#### Métricas de Qualidade
* **Tempo de Resposta:** Todas as transações financeiras críticas devem ter tempo de resposta < 2 segundos.
* **Uptime (Disponibilidade):** O sistema deve manter 99,999% de disponibilidade.
* **Taxa de Fraude:** A meta é reduzir as fraudes em 40%.
* **Cobertura de Testes:** Garantir >90% de cobertura de testes unitários para os microserviços de Transação e Conta.

#### Análise de Riscos e Mitigação
| Risco Identificado | Nível | Mitigação Proposta |
| :--- | :--- | :--- |
| **Ataques Cibernéticos (Phishing, DDoS)** | Alto | Implementar WAF (Web Application Firewall), monitoramento em tempo real (como o simulado no Caso 7) e treinamento de usuários. |
| **Vazamento de Dados Financeiros (LGPD)** | Alto | Criptografia de ponta a ponta e em repouso. Auditoria e trilhas de log para todas as transações. |
| **Indisponibilidade em Horários de Pico** | Médio | Arquitetura de microserviços em nuvem com auto-scaling. Testes de carga (como o Caso 8) para identificar gargalos. |
| **Não Conformidade Regulatória (BACEN)** | Alto | Consultoria regulatória contínua. Garantir que todas as transações (PIX, TED) sigam as APIs oficiais e regras de conformidade. |

## Etapa 6: Reflexão Crítica

Esta seção aborda a "Reflexão Final", respondendo às questões propostas.

1.  **Como equilibrar usabilidade com segurança?**
    O equilíbrio é alcançado através da "autenticação adaptativa". O `docs/Requisitos.pdf` sugere usar cache inteligente para dispositivos confiáveis (login rápido) e exigir 2FA (como biometria) apenas para ações sensíveis (como transferências altas ou visualização de dados detalhados), em vez de em cada login.

2.  **Quais trade-offs entre custo de infraestrutura e escalabilidade?**
    O principal trade-off é entre custo fixo (servidores dedicados) e custo variável (nuvem). A arquitetura de microserviços é mais cara para iniciar (complexidade), mas oferece escalabilidade elástica (paga-se mais em horários de pico, mas economiza na baixa), o que é ideal para atingir 5 milhões de contas sem superprovisionamento.

3.  **Como usar IA para reduzir fraudes sem prejudicar a experiência?**
    A IA (Machine Learning) não deve bloquear transações suspeitas imediatamente (o que gera "falsos positivos" e frustra o usuário). Ela deve:
    * **Atuar em tempo real:** Analisar padrões (como no "Alerta de fraude simulado") e atribuir um "score de risco".
    * **Solicitar Verificação:** Para riscos médios, em vez de bloquear, o sistema pede uma segunda forma de autenticação (ex: biometria facial).
    * **Bloquear Apenas o Crítico:** O bloqueio automático (como no Caso 7) só ocorre em padrões de risco óbvios e muito altos (ex: "lavagem de centavos").

4.  **Quais desafios legais surgem ao operar em múltiplos países?**
    * **Conformidade de Dados:** Cada país tem sua própria LGPD (como o GDPR na Europa). A infraestrutura deve ser capaz de isolar dados de cidadãos por região.
    * **Conformidade Regulatória:** Cada país tem seu próprio "Banco Central" (BACEN) com regras diferentes para KYC, PIX (ou equivalentes) e combate à lavagem de dinheiro (AML).
    * **Linguagem:** O `docs/Requisitos.pdf` nota que, mesmo com suporte multilingue, os documentos oficiais (extratos PDF) devem seguir o idioma oficial da regulação local (ex: Português no Brasil).

## 🌿 Estrutura de Branches (Repositório Git com branches organizadas)

Este repositório segue um modelo Git Flow simplificado para atender ao requisito de "branches organizadas":

* **`main`**: Branch principal. Contém apenas o código estável e entregável (versão final).
* **`develop`**: Branch de integração. Todo o desenvolvimento e novas funcionalidades são mescladas aqui antes de irem para a `main`.
* **`feature/*`**: Branches de funcionalidade (ex: `feature/pagina-pix`, `feature/dark-mode`). Elas são criadas a partir da `develop` e mescladas de volta na `develop` via Pull Request.
