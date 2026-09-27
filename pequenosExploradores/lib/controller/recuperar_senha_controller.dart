import 'package:flutter/material.dart';

class RecuperarSenhaController extends ChangeNotifier {

  String _email = '';

  String get email => _email;

  void setEmail(String novoEmail){
      _email = novoEmail;
      notifyListeners();
  }

}