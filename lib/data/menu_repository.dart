import 'package:frangof/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuRepository {
  // Aqui definimos o cliente Supabase
  final SupabaseClient _db = Supabase.instance.client;

  // Exemplo de método
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _db
        .from('categories')
        .select('id, name, description, icon')
        .order('name');

    final List data = response as List;
    return data
        .map((e) => CategoryModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
