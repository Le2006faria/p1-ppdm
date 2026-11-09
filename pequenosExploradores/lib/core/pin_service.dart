import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Confere o PIN de 4 números que o responsável criou no cadastro.
class PinService {
  PinService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const String _chaveLocal = 'pin_responsavel';

  // Guarda a cópia local (chamada pelo cadastro e pelo login)
  Future<void> salvarPinLocal(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveLocal, pin.trim());
  }

  // Área dos pais: compara com o PIN salvo em usuarios
  Future<bool> validarPinLogado(String pinDigitado) async {
    final usuario = _auth.currentUser;
    if (usuario == null) return false;

    final doc = await _db.collection('usuarios').doc(usuario.uid).get();
    final pinSalvo = doc.data()?['pin']?.toString();

    return pinSalvo != null && pinSalvo == pinDigitado.trim();
  }

  // Recuperar senha: compara com a cópia guardada no aparelho
  Future<bool> validarPinLocal(String pinDigitado) async {
    final prefs = await SharedPreferences.getInstance();
    final pinSalvo = prefs.getString(_chaveLocal);

    return pinSalvo != null && pinSalvo == pinDigitado.trim();
  }
}
