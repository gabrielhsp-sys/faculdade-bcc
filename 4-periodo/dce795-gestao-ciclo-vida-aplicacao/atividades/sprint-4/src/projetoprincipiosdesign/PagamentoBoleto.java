package projetoprincipiosdesign;

public class PagamentoBoleto implements Pagamento, GeraBoleto {
    @Override
    public void pagar(double valor) {
        gerarBoleto(valor);
    }

    @Override
    public void gerarBoleto(double valor) {
        System.out.printf("Linha digitável gerada para R$ %.2f%n", valor);
    }
}
