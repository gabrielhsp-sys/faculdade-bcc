package projetoprincipiosdesign;

public class PedidoService {
    private final PedidoRepository repository;

    public PedidoService(PedidoRepository repository) {
        this.repository = repository;
    }

    public double calcularTotal(Pedido pedido, Desconto desconto) {
        return desconto.calcular(pedido.calcularSubtotal());
    }

    public String obterCidadeEntrega(Pedido pedido) {
        return pedido.getCidadeEntrega();
    }

    public void finalizarPedido(Pedido pedido, Desconto desconto, Pagamento pagamento) {
        double total = calcularTotal(pedido, desconto);

        System.out.println("Salvando pedido em arquivo...");
        repository.salvar(pedido, total);

        System.out.println("Gerando resumo do pedido...");
        System.out.println("Cliente: " + pedido.getNomeCliente());
        System.out.printf("Total: R$ %.2f%n", total);

        pagamento.pagar(total);

        System.out.println(
            "Enviando mensagem para " + pedido.getNomeCliente() + ": pedido finalizado."
        );
    }
}
