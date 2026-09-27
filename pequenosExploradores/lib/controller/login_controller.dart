import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier{

  String _email = '';
  String _senha = '';

  String get email => _email;
  String get senha => _senha;

  void setEmail(String novoEmail){
      _email = novoEmail;
      notifyListeners();
  }

  void setSenha(String novaSenha){
      _senha = novaSenha;
      notifyListeners();
  }

}
