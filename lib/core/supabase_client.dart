// core/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AppSupabase {
  static Future init() async {
    await Supabase.initialize(
      url: 'https://bvsdtizprfrnaszshgcb.supabase.co',
      anonKey: 'sb_publishable_-xDforHprC36Ovp8ocmToA_0na2QuJf',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
