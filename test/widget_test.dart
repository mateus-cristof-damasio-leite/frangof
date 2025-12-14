import 'package:flutter/material.dart';
import 'package:frangof/pages/login/login_page.dart';

class FrangoApp extends StatelessWidget {
  // Remova o `const` se LoginPage não for const
  FrangoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frango do Vizinho',
      home: LoginPage(), // LoginPage não é const
    );
  }
}
