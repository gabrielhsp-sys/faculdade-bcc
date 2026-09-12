package projetoprincipiosdesign;

import java.util.List;

public class Pedido {
    private Cliente cliente;
    private List<ItemPedido> itens;

    public Pedido(Cliente cliente, List<ItemPedido> itens) {
        this.cliente = cliente;
        this.itens = itens;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public List<ItemPedido> getItens() {
        return itens;
    }

    public void setItens(List<ItemPedido> itens) {
        this.itens = itens;
    }

    public String getNomeCliente() {
        return cliente.getNome();
    }

    public String getCidadeEntrega() {
        return cliente.getCidadeEntrega();
    }

    public double calcularSubtotal() {
        double subtotal = 0.0;

        for (ItemPedido item : itens) {
            subtotal += item.getPreco() * item.getQuantidade();
        }

        return subtotal;
    }
}
