import 'package:flutter/material.dart';

class PrincipalController extends ChangeNotifier {
  String _nomeCrianca = 'Criança';

  String get nomeCrianca => _nomeCrianca;

  void setNomeCrianca(String nome) {
    _nomeCrianca = nome;
    notifyListeners();
  }
}