/*

Trabalho de Controle e Estatísticas de Base de Dados.
Este programa gerencia um banco de dados de imóveis, permitindo incluir, excluir, buscar e gerar estatísticas sobre os imóveis cadastrados.

Autor: Gabriel Henrique Silva Pereira
RA: 2025.1.08.036
Autor: Otávio de Oliveira
RA: 2025.1.08.034

*/

#include <iostream>   // Para entrada e saída padrão (cin, cout)
#include <fstream>    // Para manipulação de arquivos (ifstream, ofstream)
#include <sstream>    // Para manipulação de strings como streams (stringstream)
#include <string>     // Para utilizar a classe string
#include <iomanip>    // Para formatação de saída (setprecision, fixed)
using namespace std;


// Define o número máximo de imóveis que podem ser cadastrados
const int MAX_IMOVEIS = 200;

// Estrutura que representa um imóvel com todos os seus atributos
struct Imovel {
    string tipo, finalidade, endereco, bairro, cidade;    // Informações básicas do imóvel
    float area, valor, iptu;                              // Área, valor e IPTU do imóvel
    int quartos, suites, banheiros, vagas;                // Quantidade de quartos, suítes, banheiros e vagas
    bool cozinha, sala, varanda, areaServico;             // Presença de cômodos 
    string piso, conservacao;                             // Tipo de piso e estado de conservação
    bool armarios, arCondicionado, aquecedor, ventilador; // Características adicionais 
};

// Vetor global que armazena todos os imóveis cadastrados
Imovel imoveis[MAX_IMOVEIS];
// Variável global que armazena o total de imóveis cadastrados
int totalImoveis = 0;

// Função para excluir um imóvel do vetor pelo índice
void excluir(int indice) {
    // Move todos os imóveis após o índice para uma posição anterior
    for (int i = indice; i < totalImoveis - 1; ++i)
        imoveis[i] = imoveis[i + 1]; // Copia o próximo imóvel para a posição atual
    totalImoveis--; // Decrementa o total de imóveis
}

// Função para carregar imóveis de um arquivo texto
void carregarImoveis(const string& nomeArquivo) {
    ifstream arquivo(nomeArquivo); // Abre o arquivo para leitura
    if (!arquivo.is_open()) {
        cout << "Arquivo não encontrado. Iniciando com banco vazio.\n";
        return;
    }
    
    string linha;
    getline(arquivo, linha); // Lê e ignora a primeira linha (cabeçalho)

    // Lê cada linha do arquivo até o fim ou até atingir o máximo de imóveis
    while (getline(arquivo, linha) && totalImoveis < MAX_IMOVEIS) {
        stringstream ss(linha); // Cria um stream para ler os dados da linha
        Imovel& im = imoveis[totalImoveis]; // Referência para o próximo imóvel
        ss >> im.tipo; // Lê o tipo do imóvel
        if (im.tipo == "fim") break; // Para se encontrar o marcador de fim
        ss >> im.finalidade >> im.endereco >> im.bairro >> im.cidade; // Lê os campos de string
        ss >> im.area >> im.valor >> im.iptu; // Lê os campos float
        ss >> im.quartos >> im.suites >> im.banheiros >> im.vagas; // Lê os campos int
        string temp;
        ss >> temp; im.cozinha = (temp == "sim"); // Converte string para bool
        ss >> temp; im.sala = (temp == "sim");
        ss >> temp; im.varanda = (temp == "sim");
        ss >> temp; im.areaServico = (temp == "sim");
        ss >> im.piso >> im.conservacao; // Lê piso e conservação
        ss >> temp; im.armarios = (temp == "sim");
        ss >> temp; im.arCondicionado = (temp == "sim");
        ss >> temp; im.aquecedor = (temp == "sim");
        ss >> temp; im.ventilador = (temp == "sim");
        totalImoveis++; // Incrementa o total de imóveis cadastrados
    }
    arquivo.close(); 
}

// Função para salvar todos os imóveis no arquivo texto
void salvarImoveis(const string& nomeArquivo) {
    ofstream arquivo(nomeArquivo); // Abre o arquivo para escrita
    if (!arquivo.is_open()) {
        cout << "Erro ao abrir arquivo para escrita.\n";
        return;
    }
    
    // Escreve o cabeçalho no arquivo
    arquivo << "tipo finalidade endereco bairro cidade area valor iptu quartos suites banheiros vagas cozinha sala varanda areaServico piso conservacao armarios arCondicionado aquecedor ventilador\n";
    // Escreve os dados de cada imóvel
    for (int i = 0; i < totalImoveis; ++i) {
        Imovel& im = imoveis[i];
        arquivo << im.tipo << ' ' << im.finalidade << ' ' << im.endereco << ' ' << im.bairro << ' ' << im.cidade << ' ';
        arquivo << im.area << ' ' << im.valor << ' ' << im.iptu << ' ';
        arquivo << im.quartos << ' ' << im.suites << ' ' << im.banheiros << ' ' << im.vagas << ' ';
        // Salva os valores booleanos como "sim" ou "não"
        arquivo << (im.cozinha ? "sim" : "não") << ' ';
        arquivo << (im.sala ? "sim" : "não") << ' ';
        arquivo << (im.varanda ? "sim" : "não") << ' ';
        arquivo << (im.areaServico ? "sim" : "não") << ' ';
        arquivo << im.piso << ' ' << im.conservacao << ' ';
        arquivo << (im.armarios ? "sim" : "não") << ' ';
        arquivo << (im.arCondicionado ? "sim" : "não") << ' ';
        arquivo << (im.aquecedor ? "sim" : "não") << ' ';
        arquivo << (im.ventilador ? "sim" : "não") << '\n';
    }
    arquivo << "fim" << endl; 
    arquivo.close(); 
}

// Função auxiliar para ler resposta sim/não e converter para bool
bool lerSimNao(const string& mensagem) {
    string resposta;
    while (true) {
        cout << mensagem << " (sim/não): "; // Solicita resposta ao usuário
        cin >> resposta;
        // Converte para minúsculas para comparação mais robusta
        for (int i = 0; i < resposta.length(); i++) {
            resposta[i] = tolower(resposta[i]);
        }
        if (resposta == "sim" || resposta == "s") return true;
        if (resposta == "nao" || resposta == "não" || resposta == "n") return false;
        cout << "Resposta inválida. Digite 'sim' ou 'não'.\n"; // Mensagem de erro
    }
}

// Função para incluir um novo imóvel no vetor
void incluirImovel() {
    if (totalImoveis >= MAX_IMOVEIS) { // Verifica se atingiu o limite
        cout << "Limite máximo de imóveis atingido.\n";
        return;
    }
    Imovel& im = imoveis[totalImoveis]; // Referência para o novo imóvel
    // Solicita ao usuário os dados do imóvel
    cout << "Digite os dados do novo imóvel:\n";
    cout << "Tipo: "; cin >> im.tipo;
    cout << "Finalidade: "; cin >> im.finalidade;
    cout << "Endereço: "; cin >> im.endereco;
    cout << "Bairro: "; cin >> im.bairro;
    cout << "Cidade: "; cin >> im.cidade;
    
    // Validação de entrada para campos numéricos
    do {
        cout << "Área: "; cin >> im.area;
        if (im.area <= 0) cout << "Área deve ser maior que zero.\n";
    } while (im.area <= 0);
    
    do {
        cout << "Valor: "; cin >> im.valor;
        if (im.valor <= 0) cout << "Valor deve ser maior que zero.\n";
    } while (im.valor <= 0);
    
    do {
        cout << "IPTU: "; cin >> im.iptu;
        if (im.iptu < 0) cout << "IPTU não pode ser negativo.\n";
    } while (im.iptu < 0);
    
    do {
        cout << "Quartos: "; cin >> im.quartos;
        if (im.quartos < 0) cout << "Número de quartos não pode ser negativo.\n";
    } while (im.quartos < 0);
    
    do {
        cout << "Suítes: "; cin >> im.suites;
        if (im.suites < 0) cout << "Número de suítes não pode ser negativo.\n";
    } while (im.suites < 0);
    
    do {
        cout << "Banheiros: "; cin >> im.banheiros;
        if (im.banheiros < 0) cout << "Número de banheiros não pode ser negativo.\n";
    } while (im.banheiros < 0);
    
    do {
        cout << "Vagas: "; cin >> im.vagas;
        if (im.vagas < 0) cout << "Número de vagas não pode ser negativo.\n";
    } while (im.vagas < 0);
    
    im.cozinha = lerSimNao("Cozinha");
    im.sala = lerSimNao("Sala");
    im.varanda = lerSimNao("Varanda");
    im.areaServico = lerSimNao("Área de serviço");
    cout << "Piso: "; cin >> im.piso;
    cout << "Conservação: "; cin >> im.conservacao;
    im.armarios = lerSimNao("Armários");
    im.arCondicionado = lerSimNao("Ar-condicionado");
    im.aquecedor = lerSimNao("Aquecedor");
    im.ventilador = lerSimNao("Ventilador");
    totalImoveis++; // Incrementa o total de imóveis
    cout << "Imóvel incluído com sucesso!\n";
}

// Função para buscar um imóvel pelo endereço (rua) e permitir exclusão se encontrado
void buscarPorRua() {
    if (totalImoveis == 0) {
        cout << "Nenhum imóvel cadastrado.\n";
        return;
    }
    
    string rua;
    cout << "Digite o endereço (rua) do imóvel para buscar: ";
    cin >> rua;
    bool encontrado = false;
    // Procura o imóvel pelo endereço
    for (int i = 0; i < totalImoveis; ++i) {
        if (imoveis[i].endereco == rua) {
            encontrado = true;
            cout << "Imóvel encontrado:\n";
            cout << "Endereço: " << imoveis[i].endereco << ", Tipo: " << imoveis[i].tipo << ", Valor: " << imoveis[i].valor << endl;
            string resposta;
            do {
                cout << "Deseja excluir este imóvel? (sim/não): ";
                cin >> resposta;
                // Converte para minúsculas
                for (int j = 0; j < resposta.length(); j++) {
                    resposta[j] = tolower(resposta[j]);
                }
                if (resposta == "sim" || resposta == "s") {
                    excluir(i); // Exclui o imóvel encontrado
                    cout << "Imóvel removido com sucesso.\n";
                    return;
                } else if (resposta == "nao" || resposta == "não" || resposta == "n") {
                    cout << "Exclusão cancelada.\n";
                    return;
                } else {
                    cout << "Resposta inválida. Digite 'sim' ou 'não'.\n";
                }
            } while (true);
        }
    }
    if (!encontrado) {
        cout << "Imóvel não encontrado.\n";
    }
}

// Função para buscar imóveis dentro de uma faixa de valor
void buscarPorFaixaValor() {
    if (totalImoveis == 0) {
        cout << "Nenhum imóvel cadastrado.\n";
        return;
    }
    
    float min, max;
    do {
        cout << "Digite o valor mínimo: "; cin >> min;
        cout << "Digite o valor máximo: "; cin >> max;
        if (min < 0 || max < 0) {
            cout << "Valores não podem ser negativos.\n";
        } else if (min > max) {
            cout << "Valor mínimo não pode ser maior que o máximo.\n";
        }
    } while (min < 0 || max < 0 || min > max);
    
    bool encontrou = false;
    cout << "\nImóveis encontrados na faixa de R$ " << fixed << setprecision(2) << min << " a R$ " << max << ":\n";
    // Percorre todos os imóveis e exibe os que estão na faixa
    for (int i = 0; i < totalImoveis; ++i) {
        if (imoveis[i].valor >= min && imoveis[i].valor <= max) {
            cout << i + 1 << ". " << imoveis[i].endereco << ", Valor: R$ " << imoveis[i].valor << ", Finalidade: " << imoveis[i].finalidade << endl;
            encontrou = true;
        }
    }
    if (!encontrou) {
        cout << "Nenhum imóvel encontrado nesta faixa de valor.\n";
    }
}

// Função para buscar imóveis por características específicas
void buscarPorCaracteristicas() {
    if (totalImoveis == 0) {
        cout << "Nenhum imóvel cadastrado.\n";
        return;
    }
    
    bool arm, ar, aq, vent;
    cout << "Informe as características desejadas:\n";
    arm = lerSimNao("Armários");
    ar = lerSimNao("Ar-condicionado");
    aq = lerSimNao("Aquecedor");
    vent = lerSimNao("Ventilador");
    
    bool encontrou = false;
    cout << "\nImóveis encontrados com as características especificadas:\n";
    // Percorre todos os imóveis e exibe os que possuem as características informadas
    for (int i = 0; i < totalImoveis; ++i) {
        Imovel& im = imoveis[i];
        if (im.armarios == arm && im.arCondicionado == ar && im.aquecedor == aq && im.ventilador == vent) {
            cout << i + 1 << ". " << im.endereco << ", Tipo: " << im.tipo << ", Valor: R$ " << fixed << setprecision(2) << im.valor << endl;
            encontrou = true;
        }
    }
    if (!encontrou) {
        cout << "Nenhum imóvel encontrado com essas características.\n";
    }
}

// Função para buscar imóveis por número de quartos e suítes
void buscarPorQuartosSuites() {
    if (totalImoveis == 0) {
        cout << "Nenhum imóvel cadastrado.\n";
        return;
    }
    
    int quartos, suites;
    do {
        cout << "Número de quartos: "; cin >> quartos;
        if (quartos < 0) cout << "Número de quartos não pode ser negativo.\n";
    } while (quartos < 0);
    
    do {
        cout << "Número de suítes: "; cin >> suites;
        if (suites < 0) cout << "Número de suítes não pode ser negativo.\n";
    } while (suites < 0);
    
    bool encontrou = false;
    cout << "\nImóveis encontrados com " << quartos << " quartos e " << suites << " suítes:\n";
    // Percorre todos os imóveis e exibe os que possuem a quantidade informada
    for (int i = 0; i < totalImoveis; ++i) {
        if (imoveis[i].quartos == quartos && imoveis[i].suites == suites) {
            cout << i + 1 << ". " << imoveis[i].endereco << ", Tipo: " << imoveis[i].tipo << ", Valor: R$ " << fixed << setprecision(2) << imoveis[i].valor << endl;
            encontrou = true;
        }
    }
    if (!encontrou) {
        cout << "Nenhum imóvel encontrado com essa quantidade de quartos e suítes.\n";
    }
}

// Função para gerar estatísticas sobre os imóveis cadastrados
void gerarEstatisticas() {
    if (totalImoveis == 0) {
        cout << "Nenhum imóvel cadastrado para gerar estatísticas.\n";
        return;
    }
    
    int venda = 0, locacao = 0, temporada = 0, casasComSuite = 0, salasCeramica = 0;
    int totalCasas = 0, totalSalasComerciais = 0; // Contadores para denominadores específicos
    
    // Conta a quantidade de imóveis para cada categoria
    for (int i = 0; i < totalImoveis; ++i) {
        // Contadores para finalidade
        if (imoveis[i].finalidade == "venda") venda++;
        else if (imoveis[i].finalidade == "aluguel" || imoveis[i].finalidade == "locacao") locacao++;
        else if (imoveis[i].finalidade == "temporada") temporada++;
        
        // Contador para casas com suíte
        if (imoveis[i].tipo == "casa") {
            totalCasas++;
            if (imoveis[i].suites > 0) casasComSuite++;
        }
        
        // Contador para salas comerciais com piso cerâmica
        if (imoveis[i].tipo == "sala_comercial") {
            totalSalasComerciais++;
            if (imoveis[i].piso == "ceramica" || imoveis[i].piso == "cerâmica") salasCeramica++;
        }
    }
    
    cout << fixed << setprecision(2); // Define precisão de casas decimais
    
    // Exibe as estatísticas em porcentagem
    cout << "\n=== ESTATÍSTICAS DOS IMÓVEIS ===\n";
    cout << "Total de imóveis cadastrados: " << totalImoveis << "\n\n";
    
    // Porcentagens por finalidade (baseadas no total de imóveis)
    cout << "FINALIDADE DOS IMÓVEIS:\n";
    cout << "Imóveis para venda: " << (venda * 100.0 / totalImoveis) << "% (" << venda << " imóveis)\n";
    cout << "Imóveis para locação: " << (locacao * 100.0 / totalImoveis) << "% (" << locacao << " imóveis)\n";
    cout << "Imóveis para temporada: " << (temporada * 100.0 / totalImoveis) << "% (" << temporada << " imóveis)\n\n";
    
    // Porcentagem de casas com suíte (baseada apenas no total de casas)
    cout << "CASAS COM SUÍTE:\n";
    if (totalCasas > 0) {
        cout << "Casas com suíte: " << (casasComSuite * 100.0 / totalCasas) << "% (" << casasComSuite << " de " << totalCasas << " casas)\n";
    } else {
        cout << "Nenhuma casa cadastrada no sistema.\n";
    }
    
    // Porcentagem de salas comerciais com piso cerâmica (baseada apenas no total de salas comerciais)
    cout << "\nSALAS COMERCIAIS COM PISO CERÂMICA:\n";
    if (totalSalasComerciais > 0) {
        cout << "Salas comerciais com piso cerâmica: " << (salasCeramica * 100.0 / totalSalasComerciais) << "% (" << salasCeramica << " de " << totalSalasComerciais << " salas)\n";
    } else {
        cout << "Nenhuma sala comercial cadastrada no sistema.\n";
    }
    cout << "================================\n";
}

// Função para listar todos os imóveis cadastrados
void listarImoveis() {
    if (totalImoveis == 0) {
        cout << "Nenhum imóvel cadastrado.\n";
        return;
    }
    cout << "\n=== LISTA DE TODOS OS IMÓVEIS ===\n";
    // Percorre e exibe informações resumidas de cada imóvel
    for (int i = 0; i < totalImoveis; ++i) {
        cout << i + 1 << ". Endereço: " << imoveis[i].endereco 
             << ", Tipo: " << imoveis[i].tipo 
             << ", Finalidade: " << imoveis[i].finalidade
             << ", Valor: R$ " << fixed << setprecision(2) << imoveis[i].valor << endl;
    }
    cout << "================================\n";
}

// Função que exibe o menu principal e executa as operações escolhidas pelo usuário
void menu() {
    int opcao;
    do {
        // Exibe as opções do menu
        cout << "\n--- MENU ---\n";
        cout << "1. Incluir novo imóvel\n";
        cout << "2. Buscar imóvel por rua\n";
        cout << "3. Buscar por faixa de valor\n";
        cout << "4. Buscar por características\n";
        cout << "5. Buscar por quartos e suítes\n";
        cout << "6. Gerar estatísticas\n";
        cout << "7. Listar imóveis\n";
        cout << "0. Sair\n";
        cout << "Escolha uma opção: ";
        cin >> opcao;
        
        // Executa a função correspondente à opção escolhida
        switch (opcao) {
            case 1: incluirImovel(); break; // Incluir novo imóvel
            case 2: buscarPorRua(); break; // Excluir imóvel por rua
            case 3: buscarPorFaixaValor(); break; // Buscar por faixa de valor
            case 4: buscarPorCaracteristicas(); break; // Buscar por características
            case 5: buscarPorQuartosSuites(); break; // Buscar por quartos e suítes
            case 6: gerarEstatisticas(); break; // Gerar estatísticas
            case 7: listarImoveis(); break; // Listar imóveis
            case 0: 
                salvarImoveis("BD_Imoveis2.txt"); 
                cout << "Dados salvos com sucesso!\n";
                cout << "Saindo...\n"; 
                cout << "*--------------------------------*\n";
                cout << "* Gabriel Henrique Silva Pereira *\n"; 
                cout << "* RA: 2025.1.08.036              *\n";
                cout << "* Otávio de Oliveira             *\n"; 
                cout << "* RA: 2025.1.08.034              *\n";
                cout << "*--------------------------------*\n"; 
                break; // Sair e salvar
            default: cout << "Opção inválida. Escolha uma opção de 0 a 7.\n";
        }
    } while (opcao != 0); // Repete até o usuário escolher sair
}

// Função principal do programa
int main() {
    cout << "=== SISTEMA DE GERENCIAMENTO DE IMÓVEIS ===\n";
    carregarImoveis("BD_Imoveis2.txt"); // Carrega os imóveis do arquivo ao iniciar
    cout << "Imóveis carregados: " << totalImoveis << endl;
    menu();                             // Chama o menu principal
    return 0;
}
