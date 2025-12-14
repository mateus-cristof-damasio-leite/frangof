import 'package:flutter/material.dart';
import 'package:frangof/controllers/cart_controller.dart';
import '../cart/cart_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> menuItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
    CartController.instance.loadCart();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await supabase
          .from('menu_items')
          .select('*')
          .eq('available', true)
          .order('category_id', ascending: true);

      setState(() {
        menuItems = List<Map<String, dynamic>>.from(response);
        loading = false;
      });
    } catch (_) {
      loading = false;
      setState(() {});
    }
  }

  void addToCart(Map<String, dynamic> item) async {
    await CartController.instance.addItem({
      'id': item['id'].toString(),
      'name': item['name'],
      'price_cents': item['price_cents'],
    });
    setState(() {});
  }

  void removeFromCart(String productId) async {
    await CartController.instance.removeItem(productId);
    setState(() {});
  }

  int getQuantity(String productId) {
    return CartController.instance.items[productId]?.quantity ?? 0;
  }

  void confirmarPedido() {
    if (CartController.instance.list.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Cardápio',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          // LOGO DE FUNDO
          Center(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset('assets/images/logo.png', width: 280),
            ),
          ),

          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final productId = item['id'].toString();
              final quantity = getQuantity(productId);

              final name = item['name'] ?? '';
              final price = (item['price_cents'] / 100).toStringAsFixed(2);
              final imageName = item['image_url'] ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.45),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGEM LOCAL
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      child: imageName.isNotEmpty
                          ? Image.asset(
                              'lib/assets/images/$imageName',
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imageFallback(),
                            )
                          : _imageFallback(),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'R\$ $price',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          quantity == 0
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () => addToCart(item),
                                  child: const Text(
                                    'Adicionar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.orange),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () =>
                                            removeFromCart(productId),
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () => addToCart(item),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.orange, width: 0.3)),
        ),
        child: ElevatedButton(
          onPressed: CartController.instance.list.isEmpty
              ? null
              : confirmarPedido,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            'Confirmar pedido • R\$ ${CartController.instance.total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 170,
      color: Colors.black,
      child: const Center(
        child: Icon(Icons.fastfood, color: Colors.orange, size: 60),
      ),
    );
  }
}
