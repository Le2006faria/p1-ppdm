import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrmacao/model/jogo_portugues_model.dart';

// Guarda o banco de palavras, sorteia cada rodada, registra as respostas da criança e calcula a quantidade de acertos
class JogoPortuguesController extends ChangeNotifier {
    JogoPortuguesController({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance {
    _stream = _criarStream();
  }

  final FirebaseFirestore _db;
  static const int _palavrasPorRodada = 4;

  // o StreamBuilder reconectaria a cada rebuild
  late Stream<List<ItemPalavra>> _stream;
  Stream<List<ItemPalavra>> get palavrasStream => _stream;

  Stream<List<ItemPalavra>> _criarStream() {
    return _db.collection('palavras').snapshots().map(
          (snap) => snap.docs
              .map(ItemPalavra.fromFirestore)
              .where((p) => p.texto.isNotEmpty)
              .toList(),
        );
  }

  // "Tentar de novo" depois de um erro: abre um stream novo
  void recarregar() {
    _stream = _criarStream();
    notifyListeners();
  }

    List<String> _idsRodada = [];
  List<ItemPalavra> _rodadaAtual = [];
  final Map<String, bool> _respostas = {};
  bool _conferido = false;

  bool get conferido => _conferido;
  List<ItemPalavra> get rodadaAtual => _rodadaAtual;

  // Chamado pelo StreamBuilder a cada atualização do Firestore
  List<ItemPalavra> montarRodada(List<ItemPalavra> banco) {
    final porId = {for (final p in banco) p.id: p};
    final tamanho = min(_palavrasPorRodada, banco.length);

    final rodadaValida =
        _idsRodada.length == tamanho && _idsRodada.every(porId.containsKey);

    if (!rodadaValida) {
      final copia = List<ItemPalavra>.from(banco)..shuffle();
      _idsRodada = copia.take(tamanho).map((p) => p.id).toList();
      _respostas.clear();
      _conferido = false;
    }

    _rodadaAtual = _idsRodada.map((id) => porId[id]!).toList();
    return _rodadaAtual;
  }

  // Resposta marcada pela criança (null = ainda não marcou)
  bool? respostaDe(String id) => _respostas[id];

  void responder(ItemPalavra item, bool valor) {
    if (_conferido) return;
    _respostas[item.id] = valor;
    notifyListeners();
  }

  int conferir() {
    _conferido = true;
    final acertos =
        _rodadaAtual.where((p) => _respostas[p.id] == p.correta).length;
    notifyListeners();
    return acertos;
  }

  // "Jogar de novo": zera a rodada; o StreamBuilder sorteia outra
  void novaRodada() {
    _idsRodada = [];
    _rodadaAtual = [];
    _respostas.clear();
    _conferido = false;
    notifyListeners();
  }
}
