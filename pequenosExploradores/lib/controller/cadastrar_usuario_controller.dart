import 'package:flutter/material.dart';

class CadastrarUsuarioController extends ChangeNotifier {
  String _nomeCompleto = '';
  String _nomeUsuario = '';
  String _email = '';
  String _telefone = '';
  String _senha = '';
  String _confirmarSenha = '';
  int _quantidadeFilhos = 0;
  List<String> _nomesFilhos = [];

  String get nomeCompleto => _nomeCompleto;
  String get nomeUsuario => _nomeUsuario;
  String get email => _email;
  String get telefone => _telefone;
  String get senha => _senha;
  String get confirmarSenha => _confirmarSenha;
  int get quantidadeFilhos => _quantidadeFilhos;
  List<String> get nomesFilhos => _nomesFilhos;

  void setNomeCompleto(String novoNome) {
    _nomeCompleto = novoNome;
    notifyListeners();
  }

  void setNomeUsuario(String novoNome) {
    _nomeUsuario = novoNome;
    notifyListeners();
  }

  void setEmail(String novoEmail) {
    _email = novoEmail;
    notifyListeners();
  }

  void setTelefone(String novoTelefone) {
    _telefone = novoTelefone;
    notifyListeners();
  }

  void setSenha(String novaSenha) {
    _senha = novaSenha;
    notifyListeners();
  }

  void setConfirmarSenha(String novaSenha) {
    _confirmarSenha = novaSenha;
    notifyListeners();
  }

  void setQuantidadeFilhos(int novaQuantidade) {
    _quantidadeFilhos = novaQuantidade;

    // Ajusta a lista de nomes conforme a quantidade escolhida
    while (_nomesFilhos.length < novaQuantidade) {
      _nomesFilhos.add('');
    }
    if (_nomesFilhos.length > novaQuantidade) {
      _nomesFilhos.removeRange(novaQuantidade, _nomesFilhos.length);
    }
    notifyListeners();
  }

  void setNomeFilho(int indice, String novoNome) {
    _nomesFilhos[indice] = novoNome;
    notifyListeners();
  }
}