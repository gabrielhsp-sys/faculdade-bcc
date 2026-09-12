package projetoprincipiosdesign;

public class PagamentoPix implements Pagamento {
    @Override
    public void pagar(double valor) {
        System.out.printf("PIX pago: R$ %.2f%n", valor);
    }

}
