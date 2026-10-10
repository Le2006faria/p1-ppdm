import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:progrmacao/controller/login_controller.dart';

class PerfilController extends ChangeNotifier {
  // Só lê o e-mail do login (o login não é alterado)
  late final LoginController _login = GetIt.I.get<LoginController>();

  // Filhos pré-definidos (apenas exibição, nada é gravado)
  static const List<String> _filhosPredefinidos = ['Ana', 'João', 'José'];

  // Dados mostrados/editados na tela
  String _nomeUsuario = '';
  List<String> _nomesFilhos = [];

  // Último estado "salvo" (o que a tela de exibição mostra)
  String _nomeSalvo = '';
  List<String> _filhosSalvos = [];

  String get nomeUsuario => _nomeUsuario;
  List<String> get nomesFilhos => _nomesFilhos;

  // E-mail utilizado no login (não pode ser alterado)
  String get email => _login.email;

  // Nome tirado do e-mail do login: "maria.silva@x.com" -> "Maria Silva"
  String _nomeDoEmail(String email) {
    final parteLocal = email.trim().split('@').first.replaceAll(RegExp(r'\d'), '');
    final partes = parteLocal
        .split(RegExp(r'[._\-+]+'))
        .where((p) => p.isNotEmpty);
    return partes
        .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join(' ');
  }

  // Abre o perfil com os dados iniciais
  void carregarDados() {
    _nomeSalvo = _nomeDoEmail(_login.email);
    _filhosSalvos = List<String>.from(_filhosPredefinidos);
    cancelar();
  }

  void setNomeUsuario(String novoNome) {
    _nomeUsuario = novoNome;
    notifyListeners();
  }

  void setNomeFilho(int indice, String novoNome) {
    if (indice < 0 || indice >= _nomesFilhos.length) return;
    _nomesFilhos[indice] = novoNome;
    notifyListeners();
  }

  void adicionarFilho(String nome) {
    _nomesFilhos.add(nome);
    notifyListeners();
  }

  void removerFilho(int indice) {
    if (indice < 0 || indice >= _nomesFilhos.length) return;
    _nomesFilhos.removeAt(indice);
    notifyListeners();
  }

  // Nome do usuário e de todos os filhos precisam estar preenchidos
  bool get dadosCompletos =>
      _nomeUsuario.trim().isNotEmpty &&
      !_nomesFilhos.any((nome) => nome.trim().isEmpty);

  // Simbólico: só passa a tela de exibição a mostrar o que foi editado
  void salvar() {
    _nomeSalvo = _nomeUsuario;
    _filhosSalvos = List<String>.from(_nomesFilhos);
    notifyListeners();
  }

  // Descarta o que foi mexido e volta ao último estado salvo
  void cancelar() {
    _nomeUsuario = _nomeSalvo;
    _nomesFilhos = List<String>.from(_filhosSalvos);
    notifyListeners();
  }
}