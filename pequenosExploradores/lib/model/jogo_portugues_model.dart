// Representa uma palavra do jogo de português
// Guarda o texto exibido, o gabarito (se está escrita certo ou errado) e a resposta que a criança marcou
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemPalavra {
  final String id;
  final String texto;
  final bool correta;

  const ItemPalavra({
  required this.id,
  required this.texto,
  required this.correta,
  });

  factory ItemPalavra.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final dados = doc.data() ?? {};
  return ItemPalavra(
    id: doc.id,
    texto: (dados['texto'] ?? '').toString(),
    correta: dados['correta'] == true,
  );
}
}
