package projetoprincipiosdesign;

public interface TipoEntrega {
    boolean estaDisponivel(double total);

    double calcularFrete(double total);
}
