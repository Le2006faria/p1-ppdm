import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilController extends ChangeNotifier {
  // Dados mostrados/editados na tela
  String _nomeUsuario = '';
  List<String> _nomesFilhos = [];

  // Último estado salvo no Firestore (o que a tela de exibição mostra)
  String _nomeSalvo = '';
  List<String> _filhosSalvos = [];

  bool _carregando = false;
  String? _mensagemErro;

  String get nomeUsuario => _nomeUsuario;
  List<String> get nomesFilhos => _nomesFilhos;
  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;

  // E-mail da conta logada (não pode ser alterado)
  String get email => FirebaseAuth.instance.currentUser?.email ?? '';

  DocumentReference<Map<String, dynamic>>? get _docUsuario {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return null;
    return FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid);
  }

  // Lê o perfil do usuário logado no Firestore
  Future<void> carregarDados() async {
    final doc = _docUsuario;
    if (doc == null) {
      _mensagemErro = 'Nenhum usuário autenticado.';
      notifyListeners();
      return;
    }

    _carregando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final dados = (await doc.get()).data() ?? {};
      _nomeSalvo = (dados['nomeUsuario'] ?? dados['nomeCompleto'] ?? '')
          .toString();
      _filhosSalvos = List<String>.from(dados['filhos'] ?? const []);
      cancelar();
    } on FirebaseException catch (e) {
      _mensagemErro = e.code == 'permission-denied'
          ? 'Sem permissão para acessar os dados.'
          : 'Não foi possível carregar o perfil.';
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar o perfil.';
    }

    _carregando = false;
    notifyListeners();
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

  // Grava as alterações no Firestore. Retorna true se deu certo.
  Future<bool> salvar() async {
    final doc = _docUsuario;
    if (doc == null) {
      _mensagemErro = 'Nenhum usuário autenticado.';
      notifyListeners();
      return false;
    }

    final nome = _nomeUsuario.trim();
    final filhos = _nomesFilhos.map((n) => n.trim()).toList();

    try {
      await doc.set({
        'nomeUsuario': nome,
        'filhos': filhos,
        'atualizadoEm': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _nomeSalvo = nome;
      _filhosSalvos = filhos;
      _mensagemErro = null;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      _mensagemErro = e.code == 'permission-denied'
          ? 'Sem permissão para gravar os dados.'
          : 'Não foi possível salvar as alterações.';
    } catch (_) {
      _mensagemErro = 'Não foi possível salvar as alterações.';
    }
    notifyListeners();
    return false;
  }

  // Descarta o que foi mexido e volta ao último estado salvo
  void cancelar() {
    _nomeUsuario = _nomeSalvo;
    _nomesFilhos = List<String>.from(_filhosSalvos);
    notifyListeners();
  }
}
