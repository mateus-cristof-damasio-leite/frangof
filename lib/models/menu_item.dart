// menu_model.dart
// ignore: unused_import
import 'combo_component_model.dart';

class MenuItemModel {
  final int id;
  final String name;
  final String? description;
  final int priceCents;
  final bool isCombo;
  final int serves;
  final int? categoryId;
  final bool available;
  final List<ComboComponentModel> components;

  double get price => priceCents / 100;

  MenuItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.priceCents,
    required this.isCombo,
    required this.serves,
    this.categoryId,
    required this.available,
    this.components = const [],
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      priceCents: map['price_cents'],
      isCombo: map['is_combo'],
      serves: map['serves'],
      categoryId: map['category_id'],
      available: map['available'] ?? true,
    );
  }

  MenuItemModel copyWith({List<ComboComponentModel>? components}) {
    return MenuItemModel(
      id: id,
      name: name,
      description: description,
      priceCents: priceCents,
      isCombo: isCombo,
      serves: serves,
      categoryId: categoryId,
      available: available,
      components: components ?? this.components,
    );
  }
}

class ComboComponentModel {}
