class CartItem {
  final String id; // ID único do item no carrinho
  final String productId; // ID do produto original
  final String name; // Nome do produto
  final double price; // Preço unitário
  int quantity; // Quantidade do produto no carrinho

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
