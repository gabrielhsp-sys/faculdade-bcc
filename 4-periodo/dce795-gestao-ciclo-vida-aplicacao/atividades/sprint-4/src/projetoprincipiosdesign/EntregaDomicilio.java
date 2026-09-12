package projetoprincipiosdesign;

public class EntregaDomicilio implements TipoEntrega {
    @Override
    public boolean estaDisponivel(double total) {
        return true;
    }

    @Override
    public double calcularFrete(double total) {
        return 15.0;
    }
}
