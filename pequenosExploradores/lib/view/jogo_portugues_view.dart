import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/view/principal_view.dart';
import 'package:progrmacao/controller/jogo_portugues_controller.dart';

class JogoPortuguesView extends StatefulWidget {
  final String nomeCrianca;
  const JogoPortuguesView({super.key, this.nomeCrianca = 'Criança'});

  @override
  State<JogoPortuguesView> createState() => _JogoPortuguesViewState();
}

class _JogoPortuguesViewState extends State<JogoPortuguesView> {
  final JogoPortuguesController _controller = JogoPortuguesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrincipalView(),
                              ),
                            );
                          },
                          child: Text('>'),
                        ),

                        SizedBox(height: 10),

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

                Expanded(
                  child: ListView.separated(
                    itemCount: _controller.palavras.length,
                    separatorBuilder: (_, __) => SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final item = _controller.palavras[index];
                      return _LinhaPalavra(
                        texto: item.texto,
                        resposta: item.resposta,
                        correta: item.correta,
                        conferido: _controller.conferido,
                        onResponder: (valor) {
                          setState(() => _controller.responder(item, valor));
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

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
                      setState(() => _controller.sortear());
                    } else {
                      late int acertos;
                      setState(() => acertos = _controller.conferir());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Você acertou $acertos de ${_controller.palavras.length}!',
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

    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
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
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 16),

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
    );
  }
}

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
