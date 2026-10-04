import 'package:flutter/material.dart';
import 'package:progrmacao/model/jogo_portugues_model.dart';

class JogoPortuguesController extends ChangeNotifier {
  final List<ItemPalavra> _banco = [
    ItemPalavra(texto: 'Casa', correta: true),
    ItemPalavra(texto: 'Kasa', correta: false),
    ItemPalavra(texto: 'Séu', correta: false),
    ItemPalavra(texto: 'Céu', correta: true),
    ItemPalavra(texto: 'Cachorro', correta: true),
    ItemPalavra(texto: 'Caxorro', correta: false),
    ItemPalavra(texto: 'Bunita', correta: false),
    ItemPalavra(texto: 'Bonita', correta: true),
    ItemPalavra(texto: 'Atrasado', correta: true),
    ItemPalavra(texto: 'Atrazado', correta: false),
    ItemPalavra(texto: 'Geito', correta: false),
    ItemPalavra(texto: 'Jeito', correta: true),
  ];

  bool conferido = false;
  List<ItemPalavra> palavras = [];

  JogoPortuguesController() {
    sortear();
  }

  void sortear() {
    conferido = false;
    final copia = List<ItemPalavra>.from(_banco)..shuffle();
    palavras = copia
        .take(4)
        .map((p) => ItemPalavra(texto: p.texto, correta: p.correta))
        .toList();
  }

  void responder(ItemPalavra item, bool valor) {
    if (conferido) return;
    item.resposta = valor;
  }

  int conferir() {
    conferido = true;
    int acertos = 0;
    for (final item in palavras) {
      if (item.resposta == item.correta) acertos++;
    }
    return acertos;
  }
}
