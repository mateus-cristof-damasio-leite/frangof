import '../models/cart_item.dart';

class CartController {
  CartController._privateConstructor();

  static final CartController instance = CartController._privateConstructor();

  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;
  List<CartItem> get list => _items.values.toList();
  double get total => _items.values.fold(0, (sum, item) => sum + item.total);

  /// ⚠️ NÃO LIMPAR AQUI
  Future<void> loadCart() async {
    // no futuro: carregar do Supabase
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    final id = item['id'].toString();

    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
    } else {
      _items[id] = CartItem(
        id: id,
        productId: id,
        name: item['name'] ?? '',
        price: (item['price_cents'] ?? 0) / 100.0,
        quantity: 1,
      );
    }
  }

  Future<void> removeItem(String productId) async {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
  }

  void clear() {
    _items.clear();
  }
}
