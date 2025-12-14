import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../product/product_page.dart' as product_page;
import '../cart/cart_page.dart' as cart_page;
import '../payment/payment_page.dart';
import '../login/login_page.dart';
import 'carousel_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.local_fire_department,
              color: AppColors.orange,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Frango do Vizinho',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          // ==========================
          // LOGO DE FUNDO
          // ==========================
          Center(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset('lib/assets/images/logo.png', width: 320),
            ),
          ),

          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CarouselBanner(),
              const SizedBox(height: 28),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildSquareButton(
                    context,
                    label: "Cardápio",
                    icon: Icons.restaurant_menu,
                    color: AppColors.orange,
                    page: const product_page.ProductPage(),
                  ),
                  _buildSquareButton(
                    context,
                    label: "Carrinho",
                    icon: Icons.shopping_cart,
                    color: Colors.orangeAccent,
                    page: const cart_page.CartPage(),
                  ),
                  _buildSquareButton(
                    context,
                    label: "Pagamento",
                    icon: Icons.payment,
                    color: Colors.orange,
                    page: const PaymentPage(totalCents: 0),
                  ),
                  _buildSquareButton(
                    context,
                    label: "Login",
                    icon: Icons.login,
                    color: Colors.white,
                    page: const LoginPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTÃO QUADRADO PADRONIZADO
  // ==========================================================
  Widget _buildSquareButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
