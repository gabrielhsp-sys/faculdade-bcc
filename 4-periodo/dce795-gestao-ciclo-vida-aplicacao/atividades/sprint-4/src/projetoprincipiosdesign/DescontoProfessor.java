package projetoprincipiosdesign;

public class DescontoProfessor implements Desconto {
    @Override
    public double calcular(double subtotal) {
        return subtotal * 0.85;
    }
}
