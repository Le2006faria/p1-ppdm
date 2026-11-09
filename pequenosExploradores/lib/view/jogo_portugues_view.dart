import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/jogo_portugues_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:progrmacao/model/jogo_portugues_model.dart';

// Tela do jogo das palavras
class JogoPortuguesView extends StatefulWidget {
  final String nomeCrianca;
  const JogoPortuguesView({super.key, this.nomeCrianca = 'Criança'});

  @override
  State<JogoPortuguesView> createState() => _JogoPortuguesViewState();
}

class _JogoPortuguesViewState extends State<JogoPortuguesView> {
  final _controller = GetIt.I.get<JogoPortuguesController>();

  void _atualizar() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller.addListener(_atualizar);
  }

  @override
  void dispose() {
    _controller.removeListener(_atualizar);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Container ocupa a tela toda e serve de fundo com degradê
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade400, Colors.lightBlue.shade200],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              children: [
                // Barra superior: (botão de voltar + nome da criança)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.black, width: 2),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            textStyle: GoogleFonts.fredoka(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text('>'),
                        ),

                        SizedBox(height: 10),

                        // Selo com o nome da criança que está jogando
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.nomeCrianca,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Selo no canto direito com o logo e o nome do app
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.cubes,
                              color: Colors.cyan,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Pequenos Exploradores',
                              style: GoogleFonts.fredoka(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Cabeçalho: título + instrução do jogo
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Palavras',
                          style: GoogleFonts.fredoka(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Verifique se a palavra está correta',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                // Lista das palavras do jogo
                Expanded(
                  child: StreamBuilder<List<ItemPalavra>>(
                    stream: _controller.palavrasStream,
                    builder: (context, snapshot) {
                      // Falha: mostra aviso e permite tentar de novo
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Não foi possível carregar as palavras.\nVerifique a internet.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _controller.recarregar,
                                child: Text('Tentar de novo'),
                              ),
                            ],
                          ),
                        );
                      }

                      // Carregando
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // Coleção vazia
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhuma palavra cadastrada.',
                            style: GoogleFonts.fredoka(fontSize: 18),
                          ),
                        );
                      }

                      // Dados em tempo real
                      final rodada = _controller.montarRodada(snapshot.data!);

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 140,
                        ),
                        itemCount: rodada.length,
                        itemBuilder: (context, index) {
                          final item = rodada[index];
                          return _LinhaPalavra(
                            texto: item.texto,
                            resposta: _controller.respostaDe(item.id),
                            correta: item.correta,
                            conferido: _controller.conferido,
                            onResponder: (valor) =>
                                _controller.responder(item, valor),
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                // Botão principal: muda de função conforme o estado do jogo
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    foregroundColor: Colors.blueGrey.shade100,
                    side: BorderSide(color: Colors.black, width: 2),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: GoogleFonts.fredoka(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (_controller.conferido) {
                      _controller.novaRodada();
                    } else {
                      final acertos = _controller.conferir();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Você acertou $acertos de ${_controller.rodadaAtual.length}!',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    _controller.conferido
                        ? 'Jogar de novo'
                        : 'Conferir as respostas',
                  ),
                ),

                SizedBox(height: 75),

                // Rodapé com os direitos autorais
                Text(
                  '© 2026 Pequenos Exploradores - Todos os Direitos Reservados',
                  style: GoogleFonts.fredoka(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Uma linha do jogo: a palavra à esquerda e os botões verdadeiro e falso à direita
class _LinhaPalavra extends StatelessWidget {
  final String texto;
  final bool? resposta;
  final bool correta;
  final bool conferido;
  final ValueChanged<bool> onResponder;

  const _LinhaPalavra({
    required this.texto,
    required this.resposta,
    required this.correta,
    required this.conferido,
    required this.onResponder,
  });

  @override
  Widget build(BuildContext context) {
    Color corFundo = Colors.cyan.shade100;
    Color corTexto = Colors.cyan.shade800;

    if (conferido) {
      final acertou = resposta == correta;
      corFundo = acertou ? Colors.green.shade100 : Colors.red.shade100;
      corTexto = acertou ? Colors.green.shade800 : Colors.red.shade800;
    }

    return Column(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            padding: EdgeInsets.all(6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: corFundo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BotaoResposta(
              icone: FontAwesomeIcons.check,
              corIcone: Colors.green.shade800,
              selecionado: resposta == true,
              onTap: () => onResponder(true),
            ),
            SizedBox(width: 16),
            _BotaoResposta(
              icone: FontAwesomeIcons.xmark,
              corIcone: Colors.red.shade800,
              selecionado: resposta == false,
              onTap: () => onResponder(false),
            ),
          ],
        ),
      ],
    );
  }
}

// Botão quadradinho de resposta
class _BotaoResposta extends StatelessWidget {
  final FaIconData icone;
  final Color corIcone;
  final bool selecionado;
  final VoidCallback onTap;

  const _BotaoResposta({
    required this.icone,
    required this.corIcone,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.cyan.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selecionado ? corIcone : Colors.transparent,
            width: 3,
          ),
        ),
        child: FaIcon(icone, size: 30, color: corIcone),
      ),
    );
  }
}
