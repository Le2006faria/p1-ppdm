import 'package:flutter/material.dart';
import 'package:progrmacao/model/jogo_portugues_model.dart';

// Guarda o banco de palavras, sorteia cada rodada, registra as respostas da criança e calcula a quantidade de acertos
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

  // Indica se a rodada atual já foi conferida
  bool conferido = false;
  // Palavras da rodada atual (as 4 sorteadas do banco)
  List<ItemPalavra> palavras = [];

  // Construtor: já sorteia a primeira rodada ao criar o controller
  JogoPortuguesController() {
    sortear();
  }

  // Começa uma nova rodada: embaralha o banco e pega 4 palavras
  void sortear() {
    conferido = false;
    final copia = List<ItemPalavra>.from(_banco)..shuffle();
    palavras = copia
        .take(4)
        .map((p) => ItemPalavra(texto: p.texto, correta: p.correta))
        .toList();
  }

  // Registra a resposta da criança para uma palavra (se verdadeiro/correto ou se falso/errado)
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
