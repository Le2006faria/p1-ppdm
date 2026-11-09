import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progrmacao/core/pin_service.dart';

class AreaPaisController extends ChangeNotifier {
  AreaPaisController({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    PinService? pinService,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _db = firestore ?? FirebaseFirestore.instance,
       _pinService = pinService ?? PinService();

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final PinService _pinService;

  bool _carregando = false;
  String? _mensagemErro;
  String _nomeResponsavel = '';
  List<String> _filhos = [];
  double _limiteDiario = 60;
  double _mediaDiaria = 0;

  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;
  String get nomeResponsavel => _nomeResponsavel;
  List<String> get filhos => _filhos;
  double get limiteDiario => _limiteDiario;
  double get mediaDiaria => _mediaDiaria;

  DocumentReference<Map<String, dynamic>>? get _docUsuario {
    final usuario = _auth.currentUser;
    if (usuario == null) return null;
    return _db.collection('usuarios').doc(usuario.uid);
  }

  // Pop-up de entrada: confere o PIN digitado com o salvo no cadastro
  Future<bool> validarPin(String pin) async {
    _mensagemErro = null;

    if (pin.trim().length != 4) {
      _mensagemErro = 'Digite o PIN de 4 números.';
      notifyListeners();
      return false;
    }

    try {
      final bool ok = await _pinService.validarPinLogado(pin);
      if (!ok) _mensagemErro = 'PIN incorreto.';
      notifyListeners();
      return ok;
    } on FirebaseException catch (erro) {
      _mensagemErro = _traduzirErro(erro);
    } catch (_) {
      _mensagemErro = 'Não foi possível verificar o PIN.';
    }
    notifyListeners();
    return false;
  }

  // Carrega responsável, filhos e limites do usuário logado
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

      _nomeResponsavel = (dados['nomeCompleto'] ?? '').toString();
      _filhos = List<String>.from(dados['filhos'] ?? const []);
      _limiteDiario = (dados['limiteDiario'] as num?)?.toDouble() ?? 60;
      _mediaDiaria = (dados['mediaDiaria'] as num?)?.toDouble() ?? 0;
    } on FirebaseException catch (erro) {
      _mensagemErro = _traduzirErro(erro);
    } catch (_) {
      _mensagemErro = 'Não foi possível carregar os dados.';
    }

    _carregando = false;
    notifyListeners();
  }

  // Enquanto o slider é arrastado, só atualiza a tela
  void setLimiteDiario(double valor) {
    _limiteDiario = valor;
    notifyListeners();
  }

  // Quando o slider é solto (onChangeEnd), grava no Firestore
  Future<bool> salvarLimiteDiario() async {
    final doc = _docUsuario;
    if (doc == null) return false;

    try {
      await doc.set({
        'limiteDiario': _limiteDiario,
        'atualizadoEm': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } on FirebaseException catch (erro) {
      _mensagemErro = _traduzirErro(erro);
    } catch (_) {
      _mensagemErro = 'Não foi possível salvar o limite diário.';
    }
    notifyListeners();
    return false;
  }

  void limparMensagemErro() {
    if (_mensagemErro == null) return;
    _mensagemErro = null;
    notifyListeners();
  }

  String _traduzirErro(FirebaseException erro) {
    switch (erro.code) {
      case 'permission-denied':
        return 'Sem permissão para acessar os dados.';
      case 'unavailable':
        return 'Serviço indisponível. Verifique a internet e tente de novo.';
      case 'deadline-exceeded':
        return 'O servidor demorou para responder. Tente de novo.';
      default:
        return erro.message ?? 'Não foi possível concluir a operação.';
    }
  }
}
