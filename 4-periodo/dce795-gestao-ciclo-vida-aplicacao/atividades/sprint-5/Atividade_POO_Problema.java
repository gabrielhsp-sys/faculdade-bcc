import java.util.ArrayList;
import java.util.List;

/**
 * Atividade de revisão — Conceitos fundamentais de Orientação a Objetos
 * Disciplina: Gestão do Cico de Vida da Aplicação (DCE795)
 */

// ===================== PARTE 1 e 2 — Encapsulamento e Construtores =====================
// Esta classe representa a evolução inicial do código fornecido.
// Nas etapas seguintes, o sistema passa a trabalhar com IConsole e classes específicas.
class Console {
    private final String nome;
    private final String tipo;
    private final double preco;

    public Console(String nome, String tipo, double preco) {
        if (nome == null || nome.isBlank()) {
            throw new IllegalArgumentException("O nome do console não pode ser vazio.");
        }
        if (tipo == null || tipo.isBlank()) {
            throw new IllegalArgumentException("O tipo do console não pode ser vazio.");
        }
        if (preco < 0) {
            throw new IllegalArgumentException("O preço não pode ser negativo.");
        }

        this.nome = nome;
        this.tipo = tipo;
        this.preco = preco;
    }

    public String getNome() {
        return nome;
    }

    public String getTipo() {
        return tipo;
    }

    public double getPreco() {
        return preco;
    }
}

// ===================== PARTE 3 — Interface e Composição =====================
interface IConsole {
    void ligar();
    double calcularPreco();
    String getNome();
}

class DadosConsole {
    private final String nome;
    private final double precoBase;

    public DadosConsole(String nome, double precoBase) {
        if (nome == null || nome.isBlank()) {
            throw new IllegalArgumentException("O nome do console não pode ser vazio.");
        }
        if (precoBase < 0) {
            throw new IllegalArgumentException("O preço base não pode ser negativo.");
        }

        this.nome = nome;
        this.precoBase = precoBase;
    }

    public String getNome() {
        return nome;
    }

    public double getPrecoBase() {
        return precoBase;
    }
}

class Nintendo implements IConsole {
    private final DadosConsole dados;

    public Nintendo(String nome, double precoBase) {
        this.dados = new DadosConsole(nome, precoBase);
    }

    @Override
    public void ligar() {
        System.out.println("Nintendo ligado.");
    }

    @Override
    public double calcularPreco() {
        return dados.getPrecoBase() * 1.10;
    }

    @Override
    public String getNome() {
        return dados.getNome();
    }
}

class Playstation implements IConsole {
    protected final DadosConsole dados;

    public Playstation(String nome, double precoBase) {
        this.dados = new DadosConsole(nome, precoBase);
    }

    @Override
    public void ligar() {
        System.out.println("Playstation ligado.");
    }

    @Override
    public double calcularPreco() {
        return dados.getPrecoBase() * 1.20;
    }

    @Override
    public String getNome() {
        return dados.getNome();
    }
}

// ===================== PARTE 4 — Herança =====================
class PlaystationPortatil extends Playstation {

    public PlaystationPortatil(String nome, double precoBase) {
        super(nome, precoBase);
    }

    @Override
    public void ligar() {
        System.out.println("Playstation Portátil ligado.");
    }

    @Override
    public double calcularPreco() {
        return dados.getPrecoBase() * 1.15;
    }
}

// ===================== PARTE 5 — Polimorfismo e Extensibilidade =====================
class Xbox implements IConsole {
    private final DadosConsole dados;

    public Xbox(String nome, double precoBase) {
        this.dados = new DadosConsole(nome, precoBase);
    }

    @Override
    public void ligar() {
        System.out.println("Xbox ligado.");
    }

    @Override
    public double calcularPreco() {
        return dados.getPrecoBase() * 1.18;
    }

    @Override
    public String getNome() {
        return dados.getNome();
    }
}

class Loja {

    public void venderConsole(IConsole console) {
        console.ligar();
        System.out.printf("%s -> Preço final: R$ %.2f%n", console.getNome(), console.calcularPreco());
    }

    public void venderVarios(List<IConsole> consoles) {
        for (IConsole console : consoles) {
            venderConsole(console);
        }
    }

    public double calcularFaturamentoTotal(List<IConsole> consoles) {
        double total = 0.0;

        for (IConsole console : consoles) {
            total += console.calcularPreco();
        }

        return total;
    }
}

public class Atividade_POO_Problema {

    public static void main(String[] args) {
        IConsole nintendo = new Nintendo("Nintendo Switch", 2000.00);
        IConsole playstation = new Playstation("Playstation 5", 3000.00);
        IConsole portatil = new PlaystationPortatil("Playstation Portátil", 2500.00);

        List<IConsole> consoles = new ArrayList<>();
        consoles.add(nintendo);
        consoles.add(playstation);
        consoles.add(portatil);

        Loja loja = new Loja();

        System.out.println("=== Vendas iniciais ===");
        loja.venderVarios(consoles);
        System.out.printf("Faturamento total: R$ %.2f%n", loja.calcularFaturamentoTotal(consoles));

        IConsole xbox = new Xbox("Xbox Series X", 2800.00);
        consoles.add(xbox);

        System.out.println("\n=== Vendas após adicionar o Xbox ===");
        loja.venderVarios(consoles);
        System.out.printf("Faturamento total: R$ %.2f%n", loja.calcularFaturamentoTotal(consoles));
    }
}
