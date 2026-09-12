package projetoprincipiosdesign;

public class RetiradaLoja implements TipoEntrega {
    private static final double VALOR_MINIMO = 50.0;

    @Override
    public boolean estaDisponivel(double total) {
        return total >= VALOR_MINIMO;
    }

    @Override
    public double calcularFrete(double total) {
        if (!estaDisponivel(total)) {
            throw new IllegalStateException(
                "Retirada na loja disponível apenas para pedidos a partir de R$ 50,00."
            );
        }

        return 0.0;
    }
}
