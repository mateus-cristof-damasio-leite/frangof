import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart'; // contém FrangoApp

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bvsdtizprfrnaszshgcb.supabase.co',
    anonKey: 'sb_publishable_-xDforHprC36Ovp8ocmToA_0na2QuJf',
  );

  runApp(const FrangoApp()); // <-- Widget raiz do app
}
