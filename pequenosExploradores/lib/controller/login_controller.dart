import 'package:flutter/material.dart';

// Guarda o email e a senha digitados e valida o formato do email
class LoginController extends ChangeNotifier {
  String _email = '';
  String _senha = '';

  // Getters: permitem à View ler os valores
  String get email => _email;
  String get senha => _senha;
  
  // Indica se o email digitado tem um formato válido
  bool get emailValido {
    final regex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    return regex.hasMatch(_email.trim());
  }

  // Atualiza o email e avisa a View
  void setEmail(String novoEmail) {
    _email = novoEmail;
    notifyListeners();
  }

  // Atualiza a senha e avisa a View
  void setSenha(String novaSenha) {
    _senha = novaSenha;
    notifyListeners();
  }
}
