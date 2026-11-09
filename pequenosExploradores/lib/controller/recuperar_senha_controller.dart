import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progrmacao/core/pin_service.dart';

class RecuperarSenhaController extends ChangeNotifier {

    RecuperarSenhaController({FirebaseAuth? auth, PinService? pinService})
      : _auth = auth ?? FirebaseAuth.instance,
        _pinService = pinService ?? PinService();

  final FirebaseAuth _auth;
  final PinService _pinService;

  bool _carregando = false;
  String? _mensagemErro;

  String _email = '';

  String get email => _email;

  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;

  bool get emailValido =>
      RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(_email.trim());

  void setEmail(String novoEmail){
      _email = novoEmail;
      notifyListeners();
  }

    // Pop-up de entrada: aqui ainda não há usuário logado,
  // então o PIN é conferido com a cópia guardada no aparelho
  Future<bool> validarPin(String pin) async {
    _mensagemErro = null;

    if (pin.trim().length != 4) {
      _mensagemErro = 'Digite o PIN de 4 números.';
      notifyListeners();
      return false;
    }

    try {
      final bool ok = await _pinService.validarPinLocal(pin);
      if (!ok) _mensagemErro = 'PIN incorreto.';
      notifyListeners();
      return ok;
    } catch (_) {
      _mensagemErro = 'Não foi possível verificar o PIN.';
      notifyListeners();
      return false;
    }
  }

  // Botão "Enviar Instruções"
  Future<bool> enviarInstrucoes() async {
    _mensagemErro = null;

    if (_email.trim().isEmpty) {
      _mensagemErro = 'Informe o e-mail cadastrado!';
      notifyListeners();
      return false;
    }
    if (!emailValido) {
      _mensagemErro = 'Informe um e-mail válido!';
      notifyListeners();
      return false;
    }

    _carregando = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: _email.trim());
      return true;
    } on FirebaseAuthException catch (erro) {
      _mensagemErro = _traduzirErro(erro);
      return false;
    } catch (_) {
      _mensagemErro = 'Não foi possível enviar o e-mail de recuperação.';
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  void limparMensagemErro() {
    if (_mensagemErro == null) return;
    _mensagemErro = null;
    notifyListeners();
  }

  String _traduzirErro(FirebaseAuthException erro) {
    switch (erro.code) {
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      case 'user-not-found':
        return 'Nenhum usuário foi encontrado com este e-mail.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos e tente de novo.';
      case 'network-request-failed':
        return 'Sem conexão. Verifique a internet e tente de novo.';
      default:
        return erro.message ?? 'Não foi possível enviar o e-mail.';
    }
  }

}