package projetoprincipiosdesign;

public class DescontoAluno implements Desconto {
    @Override
    public double calcular(double subtotal) {
        return subtotal * 0.90;
    }
}
