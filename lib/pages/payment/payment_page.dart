// pages/payment/payment_page.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: unused_import
import '../../theme/colors.dart';
import '../../core/supabase_client.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';

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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.orange),
        title: const Text(
          "Pagamento",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // LOGO DE FUNDO
          Center(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset('lib/assets/images/logo.png', width: 280),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOTAL
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

                const Text(
                  "Forma de pagamento",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),

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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================
  // OPÇÃO DE PAGAMENTO
  // ==========================
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

  // ==========================
  // FUNÇÃO PARA ENVIAR WHATSAPP
  // ==========================
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

    // Substitua pelo seu número com código do país
    String numeroWhatsApp = '+5527988578389';

    String url =
        'https://wa.me/$numeroWhatsApp?text=${Uri.encodeComponent(mensagem)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp';
    }
  }

  // ==========================
  // FINALIZAR PEDIDO
  // ==========================
  Future<void> finishOrder() async {
    final user = AppSupabase.client.auth.currentUser!;
    final total = widget.totalCents / 100;
    final cartItems = CartController.instance.list;

    // 1️⃣ Salva pedido no Supabase
    await AppSupabase.client.rpc(
      'finalizar_pedido',
      params: {'p_user_id': user.id, 'p_payment_method': method},
    );

    // 2️⃣ Envia pedido via WhatsApp caso seja Pix
    if (method == "pix") {
      await enviarPedidoWhatsApp(total, cartItems);
    }

    // 3️⃣ Limpa o carrinho local
    CartController.instance.clear();

    // 4️⃣ Volta para tela inicial
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
