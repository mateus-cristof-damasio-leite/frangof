import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _removeItem(CartItem item) async {
    await CartController.instance.removeItem(item.productId);
    if (mounted) setState(() {});
  }

  void _addItem(CartItem item) async {
    await CartController.instance.addItem({
      'id': item.productId,
      'name': item.name,
      'price_cents': (item.price * 100).toInt(),
    });
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    final cartItems = cart.list;
    final total = cart.total;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Meu Carrinho',
          style: TextStyle(color: Colors.orange),
        ),
        iconTheme: const IconThemeData(color: Colors.orange),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Limpar carrinho',
            onPressed: () {
              cart.clear();
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset('assets/images/logo.png', width: 260),
            ),
          ),
          cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Carrinho vazio',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.4),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: const Icon(
                                Icons.fastfood,
                                color: Colors.orange,
                                size: 40,
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'R\$ ${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.orange),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () => _removeItem(item),
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () => _addItem(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.orange, width: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: cartItems.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PaymentPage(totalCents: (total * 100).toInt()),
                          ),
                        );
                      },
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================
// Payment Page
// ==========================
class PaymentPage extends StatefulWidget {
  final int totalCents;
  const PaymentPage({super.key, required this.totalCents});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String method = "pix";

  @override
  Widget build(BuildContext context) {
    final totalFormatted = (widget.totalCents / 100).toStringAsFixed(2);
    final _ = CartController.instance.list;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        title: const Text(
          "Pagamento",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.orange.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total do pedido",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "R\$ $totalFormatted",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _paymentOption(
              value: "pix",
              icon: Icons.qr_code,
              title: "Pix",
              subtitle: "Pagamento instantâneo",
            ),
            _paymentOption(
              value: "cartao",
              icon: Icons.credit_card,
              title: "Cartão",
              subtitle: "Crédito ou débito",
            ),
            _paymentOption(
              value: "dinheiro",
              icon: Icons.payments,
              title: "Dinheiro",
              subtitle: "Pagamento na entrega",
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: finishOrder,
                child: const Text(
                  "Finalizar Pedido",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final selected = method == value;
    return GestureDetector(
      onTap: () => setState(() => method = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? Colors.orange.withOpacity(0.15)
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? Colors.orange : Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Future<void> enviarPedidoWhatsApp(
    double total,
    List<CartItem> cartItems,
  ) async {
    String mensagem = 'Meu pedido:\n\n';
    for (var item in cartItems) {
      mensagem +=
          '${item.name} x${item.quantity} - R\$ ${(item.price * item.quantity).toStringAsFixed(2)}\n';
    }
    mensagem += '\nTotal: R\$ ${total.toStringAsFixed(2)}';

    String numeroWhatsApp = '+5527988578389';

    // Use Uri para garantir compatibilidade
    final Uri url = Uri.parse(
      'https://wa.me/$numeroWhatsApp?text=${Uri.encodeComponent(mensagem)}',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Não foi possível abrir o WhatsApp';
    }
  }

  Future<void> finishOrder() async {
    final total = widget.totalCents / 100;
    final cartItems = CartController.instance.list;

    // Envia pedido via WhatsApp se Pix
    if (method == "pix") {
      await enviarPedidoWhatsApp(total, cartItems);
    }

    // Limpa o carrinho
    CartController.instance.clear();

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
