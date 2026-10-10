import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/jogo_matematica_controller.dart';
import 'package:progrmacao/controller/login_controller.dart';

class JogoMatematicaView extends StatefulWidget {
  final String nomeCrianca;
  const JogoMatematicaView({super.key, this.nomeCrianca = 'Criança'});

  @override
  State<JogoMatematicaView> createState() => _JogoMatematicaViewState();
}

class _JogoMatematicaViewState extends State<JogoMatematicaView> {
  final ctrl = GetIt.I.get<JogoMatematicaController>();

  // Controlador do login: de onde vem o nome da criança selecionada
  final loginCtrl = GetIt.I.get<LoginController>();

  void _atualizar() => setState(() {});

  @override
  void initState() {
    super.initState();
    ctrl.limpar(); // cada vez que abre a tela, começa um jogo novo
    ctrl.addListener(_atualizar);
  }

  @override
  void dispose() {
    ctrl.removeListener(_atualizar);
    super.dispose();
  }

  void _mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fecha o pop-up
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Botão dos números (0 a 9)
  Widget _botaoNumero(String numero) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.black, width: 2),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.black, width: 2),
        ),
        textStyle: GoogleFonts.fredoka(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        ctrl.digitar(numero);
      },
      child: Text(numero),
    );
  }

  // Botão das operações (+ e -), fica destacado quando está selecionado
  Widget _botaoOperador(String operador, IconData icone) {
    final bool selecionado = ctrl.operador == operador;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selecionado
            ? Colors.cyan.shade700
            : Colors.blueGrey.shade100,
        foregroundColor: selecionado ? Colors.white : Colors.black,
        side: BorderSide(color: Colors.black, width: 2),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      onPressed: () {
        ctrl.setOperador(operador);
      },
      child: Icon(icone, size: 48),
    );
  }

  // Linha com três botões de números
  Widget _linhaNumeros(List<String> numeros) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < numeros.length; i++) ...[
          if (i > 0) SizedBox(width: 10),
          Expanded(child: _botaoNumero(numeros[i])),
        ],
      ],
    );
  }

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
                // Cabeçalho (mesmo padrão da tela de Português)
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
                            Navigator.pop(context); // volta para a tela Principal
                          },
                          child: Text('<'),
                        ),

                        SizedBox(height: 10),

                        // Nome da criança
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

                // Parte rolável da tela
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Jogo da Matemática',
                          style: GoogleFonts.fredoka(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Toque nos números e crie a conta',
                          style: GoogleFonts.fredoka(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: 25),

                        // Teclado: números à esquerda, + e - à direita
                        SizedBox(
                          height: 320,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    // Linha do 0 (centralizado)
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(child: SizedBox()),
                                          SizedBox(width: 10),
                                          Expanded(child: _botaoNumero('0')),
                                          SizedBox(width: 10),
                                          Expanded(child: SizedBox()),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: _linhaNumeros(['1', '2', '3']),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: _linhaNumeros(['4', '5', '6']),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: _linhaNumeros(['7', '8', '9']),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 12),

                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: _botaoOperador('+', Icons.add),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: _botaoOperador('-', Icons.remove),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan.shade700,
                              foregroundColor: Colors.blueGrey.shade100,
                              side: BorderSide(color: Colors.black, width: 2),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: GoogleFonts.fredoka(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              if (ctrl.podeCalcular) {
                                ctrl.calcular();
                              } else {
                                // Pop-up caso não tenha o suficiente para uma resposta
                                _mostrarAlerta(
                                  'Atenção',
                                  'Digite dois números e escolha + ou - para calcular!',
                                );
                              }
                            },
                            child: Text('Calcular'),
                          ),
                        ),

                        SizedBox(height: 15),

                        // Caixa da resposta (borda tracejada)
                        CustomPaint(
                          painter: _BordaTracejadaPainter(),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  ctrl.conta.isEmpty
                                      ? 'Monte sua conta'
                                      : ctrl.conta,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Resposta: ${ctrl.resposta}',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),

                Text(
                  '© Todos os Direitos Reservados',
                  style: GoogleFonts.fredoka(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// Desenha a borda tracejada da caixa de resposta
//
class _BordaTracejadaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(16)),
      );

    for (final metric in path.computeMetrics()) {
      double distancia = 0;
      while (distancia < metric.length) {
        canvas.drawPath(metric.extractPath(distancia, distancia + 8), paint);
        distancia += 14;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}