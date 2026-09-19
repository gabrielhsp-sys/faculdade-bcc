import java.util.ArrayList;
import java.util.List;

// Parte 1 e 2
class Console {
    private String nome;
    private String tipo;
    private double preco;

    public Console(String nome, String tipo, double preco) {
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

// Parte 3
interface IConsole {
    void ligar();
    double calcularPreco();
    String getNome();
}

class DadosConsole {
    private String nome;
    private double precoBase;

    public DadosConsole(String nome, double precoBase) {
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
    private DadosConsole dados;

    public Nintendo(String nome, double precoBase) {
        dados = new DadosConsole(nome, precoBase);
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
    protected DadosConsole dados;

    public Playstation(String nome, double precoBase) {
        dados = new DadosConsole(nome, precoBase);
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

// Parte 4
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

// Parte 5
class Xbox implements IConsole {
    private DadosConsole dados;

    public Xbox(String nome, double precoBase) {
        dados = new DadosConsole(nome, precoBase);
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
        System.out.println(console.getNome() + " -> Preço final: R$ " + console.calcularPreco());
    }

    public void venderVarios(List<IConsole> consoles) {
        for (IConsole console : consoles) {
            venderConsole(console);
        }
    }

    public double calcularFaturamentoTotal(List<IConsole> consoles) {
        double total = 0;

        for (IConsole console : consoles) {
            total += console.calcularPreco();
        }

        return total;
    }
}

public class Atividade_POO_Problema {

    public static void main(String[] args) {
        IConsole nintendo = new Nintendo("Nintendo Switch", 2000);
        IConsole playstation = new Playstation("Playstation 5", 3000);
        IConsole portatil = new PlaystationPortatil("Playstation Portátil", 2500);

        List<IConsole> consoles = new ArrayList<>();

        consoles.add(nintendo);
        consoles.add(playstation);
        consoles.add(portatil);

        Loja loja = new Loja();

        loja.venderVarios(consoles);
        System.out.println("Faturamento total: R$ " + loja.calcularFaturamentoTotal(consoles));

        System.out.println();

        IConsole xbox = new Xbox("Xbox Series X", 2800);
        consoles.add(xbox);

        loja.venderVarios(consoles);
        System.out.println("Faturamento total com Xbox: R$ " + loja.calcularFaturamentoTotal(consoles));
    }
}
