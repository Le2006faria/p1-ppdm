// Representa uma palavra do jogo de português
// Guarda o texto exibido, o gabarito (se está escrita certo ou errado) e a resposta que a criança marcou
class ItemPalavra {
  final String texto;
  final bool correta;
  bool? resposta;

  ItemPalavra({required this.texto, required this.correta, this.resposta});
}
