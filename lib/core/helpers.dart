// helpers.dart

import 'package:flutter/material.dart';

// Mostrar um snackbar de forma simples
void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// Validar email
bool isValidEmail(String email) {
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

// Converter número para moeda
String formatCurrency(double value) {
  return 'R\$ ${value.toStringAsFixed(2)}';
}
