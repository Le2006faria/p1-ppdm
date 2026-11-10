import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrmacao/core/pin_service.dart';

// Guarda o email e a senha digitados, valida o formato do email
// e faz o login/logout pelo Firebase Authentication
class LoginController extends ChangeNotifier {
  String _email = '';
  String _senha = '';
  bool _carregando = false;
  List<String> _filhos = [];

  // Getters: permitem à View ler os valores
  String get email => _email;
  String get senha => _senha;
  bool get carregando => _carregando;

  // Filhos do usuário logado (carregados do Firestore após o login)
  List<String> get filhos => _filhos;

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

  // Autentica no Firebase e carrega os filhos do usuário.
  // Retorna null se deu certo, ou a mensagem de erro.
  Future<String?> login() async {
    _carregando = true;
    notifyListeners();

    try {
      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _senha,
      );

      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(res.user!.uid)
          .get();
      final dados = doc.data() ?? {};

      _filhos = List<String>.from(dados['filhos'] ?? const []);

      // Cópia local do PIN (usada na recuperação de senha)
      final pin = dados['pin']?.toString();
      if (pin != null && pin.isNotEmpty) {
        await PinService().salvarPinLocal(pin);
      }

      _senha = '';
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'O formato do email é inválido.';
        case 'user-not-found':
          return 'Usuário não encontrado.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email ou senha incorretos.';
        case 'user-disabled':
          return 'Esta conta foi desativada.';
        case 'too-many-requests':
          return 'Muitas tentativas. Aguarde alguns minutos e tente de novo.';
        case 'network-request-failed':
          return 'Sem conexão. Verifique a internet e tente de novo.';
        default:
          return e.message ?? e.code;
      }
    } on FirebaseException catch (e) {
      await FirebaseAuth.instance.signOut();
      return e.code == 'permission-denied'
          ? 'Sem permissão para ler os dados. Verifique as regras do Firestore.'
          : 'Não foi possível carregar os dados do usuário.';
    } catch (_) {
      return 'Não foi possível entrar. Tente novamente.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Encerra a sessão do usuário (signOut dos slides)
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _email = '';
    _senha = '';
    _filhos = [];
    notifyListeners();
  }

  // E-mail do usuário autenticado ('' se ninguém estiver logado)
  String get emailLogado => FirebaseAuth.instance.currentUser?.email ?? '';
}
