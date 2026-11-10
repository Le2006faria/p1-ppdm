import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrmacao/core/pin_service.dart';

class CadastrarUsuarioController extends ChangeNotifier {
  String _nomeCompleto = '';
  String _nomeUsuario = '';
  String _email = '';
  String _telefone = '';
  String _senha = '';
  String _confirmarSenha = '';
  int _quantidadeFilhos = 0;
  String _pin = '';
  List<String> _nomesFilhos = [];
  bool _carregando = false;

  String get nomeCompleto => _nomeCompleto;
  String get nomeUsuario => _nomeUsuario;
  String get email => _email;
  String get telefone => _telefone;
  String get senha => _senha;
  String get confirmarSenha => _confirmarSenha;
  int get quantidadeFilhos => _quantidadeFilhos;
  List<String> get nomesFilhos => _nomesFilhos;
  String get pin => _pin;
  bool get carregando => _carregando;

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

  void setPin(String novoPin) {
    _pin = novoPin;
    notifyListeners();
  }

  // Cria a conta no Firebase Authentication e guarda os dados extras no
  // Firestore (coleção "usuarios", documento com o uid do usuário).
  // Retorna null se deu certo, ou a mensagem de erro para mostrar na tela.
  Future<String?> cadastrar() async {
    _carregando = true;
    notifyListeners();

    try {
      final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.trim(),
        password: _senha,
      );

      final uid = res.user!.uid;
      final filhos = _nomesFilhos.map((n) => n.trim()).toList();

      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'uid': uid,
        'nomeCompleto': _nomeCompleto.trim(),
        'nomeUsuario': _nomeUsuario.trim(),
        'email': _email.trim(),
        'telefone': _telefone.trim(),
        'pin': _pin.trim(),
        'filhos': filhos,
        'limiteDiario': 60,
        'mediaDiaria': 0,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      // Cópia local do PIN (usada na recuperação de senha)
      await PinService().salvarPinLocal(_pin);

      // O createUser já deixa o usuário logado; encerra a sessão para que
      // ele entre pela tela de Login
      await FirebaseAuth.instance.signOut();

      _limpar();
      return null;
    } on FirebaseAuthException catch (e) {
      return _traduzirErroAuth(e);
    } on FirebaseException catch (e) {
      // Falhou no Firestore: remove a conta recém-criada para não ficar órfã
      await FirebaseAuth.instance.currentUser?.delete().catchError((_) {});
      return e.code == 'permission-denied'
          ? 'Sem permissão para gravar os dados. Verifique as regras do Firestore.'
          : 'Não foi possível salvar os dados do cadastro.';
    } catch (_) {
      return 'Ocorreu um erro ao cadastrar. Tente novamente!';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  void _limpar() {
    _nomeCompleto = '';
    _nomeUsuario = '';
    _email = '';
    _telefone = '';
    _senha = '';
    _confirmarSenha = '';
    _quantidadeFilhos = 0;
    _pin = '';
    _nomesFilhos = [];
  }

  String _traduzirErroAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'O e-mail já foi cadastrado.';
      case 'invalid-email':
        return 'O e-mail é inválido.';
      case 'weak-password':
        return 'A senha é fraca. Use pelo menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Login por e-mail/senha não está habilitado no Firebase.';
      case 'network-request-failed':
        return 'Sem conexão. Verifique a internet e tente de novo.';
      default:
        return e.message ?? e.code;
    }
  }
}
