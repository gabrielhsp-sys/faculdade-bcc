package projetoprincipiosdesign;

public class DescontoFuncionario implements Desconto {
    @Override
    public double calcular(double subtotal) {
        return subtotal * 0.80;
    }
}
