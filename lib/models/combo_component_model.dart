class ComboComponentModel {
  final int id;
  final String name;
  final double price;

  const ComboComponentModel({
    required this.id,
    required this.name,
    required this.price,
  });

  /// Cria o objeto a partir de um Map (ex: Supabase)
  factory ComboComponentModel.fromMap(Map<String, dynamic> map) {
    return ComboComponentModel(
      id: map['id'] is int
          ? map['id']
          : int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'] ?? '',
      price: map['price'] is double
          ? map['price']
          : double.tryParse(map['price'].toString()) ?? 0.0,
    );
  }

  /// Converte para Map (ex: salvar no banco)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }

  /// Cria uma cópia com valores atualizados
  ComboComponentModel copyWith({int? id, String? name, double? price}) {
    return ComboComponentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  @override
  String toString() =>
      'ComboComponentModel(id: $id, name: $name, price: $price)';
}
