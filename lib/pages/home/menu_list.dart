// ==========================================================
// TELA REAL DO CARDÁPIO (BUSCA PRODUTOS NO SUPABASE)
// ==========================================================
import 'package:flutter/material.dart';
import '../../core/supabase_client.dart';
import '../../theme/colors.dart';

class MenuListPagePlaceholder extends StatefulWidget {
  const MenuListPagePlaceholder({super.key});

  @override
  State<MenuListPagePlaceholder> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPagePlaceholder> {
  List items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMenu();
  }

  Future<void> loadMenu() async {
    final res = await AppSupabase.client
        .from('menu_items')
        .select('id, name, description, price_cents, available')
        .eq('available', true)
        .order('name', ascending: true);

    setState(() {
      items = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cardápio"),
        backgroundColor: AppColors.black,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(
              child: Text(
                "Nenhum produto cadastrado.",
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final i = items[index];
                final price = (i['price_cents'] / 100).toStringAsFixed(2);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.grayLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (i['description'] != null &&
                          i['description'].toString().isNotEmpty)
                        Text(
                          i['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        "R\$ $price",
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
