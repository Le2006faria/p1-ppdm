import 'package:flutter/material.dart';

class JogoMatematicaController extends ChangeNotifier {
  // Máximo de dígitos de cada número
  static const int _maxDigitos = 4;

  String _numero1 = '';
  String _numero2 = '';
  String _operador = ''; // '+' ou '-'
  String _resposta = '';

  String get numero1 => _numero1;
  String get numero2 => _numero2;
  String get operador => _operador;
  String get resposta => _resposta;

  // Conta que está sendo montada. Ex.: "12 + 5"
  String get conta => '$_numero1 $_operador $_numero2'.trim();

  // Só dá para calcular com dois números e uma operação
  bool get podeCalcular =>
      _numero1.isNotEmpty && _operador.isNotEmpty && _numero2.isNotEmpty;

  void digitar(String digito) {
    // Se já existe uma resposta (sem operação nova), começa uma nova conta
    if (_resposta.isNotEmpty) {
      _numero1 = '';
      _numero2 = '';
      _operador = '';
      _resposta = '';
    }

    if (_operador.isEmpty) {
      if (_numero1.length < _maxDigitos) {
        _numero1 += digito;
      }
    } else {
      if (_numero2.length < _maxDigitos) {
        _numero2 += digito;
      }
    }
    notifyListeners();
  }

  void setOperador(String novoOperador) {
    // Continua a conta a partir da resposta anterior
    if (_resposta.isNotEmpty) {
      _numero1 = _resposta;
      _numero2 = '';
      _resposta = '';
    }

    // Precisa ter o primeiro número antes da operação
    if (_numero1.isEmpty) return;

    _operador = novoOperador;
    notifyListeners();
  }

  void calcular() {
    if (!podeCalcular) return;

    final int a = int.parse(_numero1);
    final int b = int.parse(_numero2);

    if (_operador == '+') {
      _resposta = (a + b).toString();
    } else {
      _resposta = (a - b).toString();
    }
    notifyListeners();
  }

  void limpar() {
    _numero1 = '';
    _numero2 = '';
    _operador = '';
    _resposta = '';
    notifyListeners();
  }
}