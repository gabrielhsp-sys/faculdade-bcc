package projetoprincipiosdesign;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class TesteRefatoracao {
    private static int testesExecutados;

    public static void main(String[] args) throws Exception {
        Cliente cliente = new Cliente(
            "Ana",
            new Endereco("Rua das Flores", new Cidade("Belo Horizonte"))
        );
        Pedido pedido = new Pedido(
            cliente,
            List.of(
                new ItemPedido("Livro", 120.0, 1),
                new ItemPedido("Caderno", 20.0, 2)
            )
        );

        Path arquivo = Files.createTempFile("pedidos-teste-", ".txt");
        PedidoService servico = new PedidoService(new PedidoRepositoryArquivo(arquivo));

        verificar("subtotal", 160.0, pedido.calcularSubtotal());
        verificar("desconto aluno", 144.0, servico.calcularTotal(pedido, new DescontoAluno()));
        verificar("desconto professor", 136.0, servico.calcularTotal(pedido, new DescontoProfessor()));
        verificar("desconto funcionário", 128.0, servico.calcularTotal(pedido, new DescontoFuncionario()));
        verificar("cidade", "Belo Horizonte", servico.obterCidadeEntrega(pedido));

        TipoEntrega domicilio = new EntregaDomicilio();
        TipoEntrega retirada = new RetiradaLoja();
        verificar("frete em domicílio", 15.0, domicilio.calcularFrete(40.0));
        verificar("retirada indisponível abaixo do mínimo", false, retirada.estaDisponivel(40.0));
        verificar("retirada disponível acima do mínimo", true, retirada.estaDisponivel(160.0));
        verificar("frete da retirada", 0.0, retirada.calcularFrete(160.0));

        servico.finalizarPedido(pedido, new DescontoAluno(), new PagamentoPix());
        verificar("pedido salvo", "Ana;144.0", Files.readString(arquivo).trim());

        Files.deleteIfExists(arquivo);
        System.out.println("Testes concluídos: " + testesExecutados + "/10.");
    }

    private static void verificar(String nome, double esperado, double obtido) {
        testesExecutados++;
        if (Math.abs(esperado - obtido) > 0.0001) {
            throw new AssertionError(nome + ": esperado " + esperado + ", obtido " + obtido);
        }
    }

    private static void verificar(String nome, Object esperado, Object obtido) {
        testesExecutados++;
        if (!esperado.equals(obtido)) {
            throw new AssertionError(nome + ": esperado " + esperado + ", obtido " + obtido);
        }
    }
}
