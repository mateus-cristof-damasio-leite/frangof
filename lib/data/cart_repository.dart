// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

class CartRepository {
  final client = AppSupabase.client;

  // Garantir que o carrinho exista
  Future<String> _ensureCart(String userId) async {
    final cart = await client
        .from('carts')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (cart == null) {
      final newCart = await client
          .from('carts')
          .insert({'user_id': userId})
          .select()
          .single();

      return newCart['id'];
    }

    return cart['id'];
  }

  // ADICIONAR ITEM AO CARRINHO (CORRIGIDO)
  Future<void> addItem(String userId, int menuItemId, int qty) async {
    final cartId = await _ensureCart(userId);

    final item = await client
        .from('menu_items')
        .select('price_cents')
        .eq('id', menuItemId)
        .single();

    final price = item['price_cents'];

    await client.from('cart_items').upsert(
      {
        'cart_id': cartId,
        'menu_item_id': menuItemId,
        'quantity': qty,
        'price_cents': price,
      },
      onConflict:
          'cart_id,menu_item_id', // <-- FUNDAMENTAL! sem isso o carrinho fica vazio
    );
  }

  // BUSCAR ITENS DO CARRINHO (CORRIGIDO)
  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final cart = await client
        .from('carts')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (cart == null) return [];

    final res = await client
        .from('cart_items')
        .select('''
        id,
        quantity,
        price_cents,
        menu_item_id,
        menu_items (
          name,
          image_url
        )
      ''')
        .eq('cart_id', cart['id']);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> removeItem(int id) async {
    await client.from('cart_items').delete().eq('id', id);
  }

  Future<void> clearCart(String userId) async {
    final cart = await client
        .from('carts')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (cart != null) {
      await client.from('cart_items').delete().eq('cart_id', cart['id']);
    }
  }
}
