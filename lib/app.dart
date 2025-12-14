import 'package:flutter/material.dart';
import 'package:frangof/pages/login/login_page.dart';
// ignore: unused_import
import 'pages/product/product_page.dart'; // ajuste o caminho
// ignore: unused_import
import 'pages/cart/cart_page.dart'; // caminho para o CartPage

class FrangoApp extends StatelessWidget {
  const FrangoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frango do Vizinho',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const LoginPage(),
    );
  }
}
