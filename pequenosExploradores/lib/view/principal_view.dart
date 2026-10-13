import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/principal_controller.dart';
import 'package:progrmacao/view/area_pais_view.dart';
import 'package:progrmacao/view/jogo_matematica_view.dart';
import 'package:progrmacao/view/jogo_portugues_view.dart';
import 'package:progrmacao/view/login_view.dart';

// Tela principal do app (menu de jogos)
class PrincipalView extends StatefulWidget {
  final String nomeCrianca;
  const PrincipalView({super.key, this.nomeCrianca = 'Criança'});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  final ctrl = GetIt.I.get<PrincipalController>();

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
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                              ),
                            );
                          },
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

                SizedBox(height: 40),

                // Cabeçalho: título + instrução
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Jogos',
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
                      'Escolha uma atividade para jogar',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50),

                //
                // Botão
                //

                // Linha com os dois botões de jogo, um em cada ponta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade700,
                          foregroundColor: Colors.blueGrey.shade100,
                          side: BorderSide(color: Colors.black, width: 2),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
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
                              builder: (context) => JogoMatematicaView(nomeCrianca: widget.nomeCrianca),
                            ),
                          );
                        },

                        // Stack sobrepõe widgets: o texto "Números" no meio e quatro ícones decorativos, um em cada canto
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(width: 8),

                            Center(
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Números',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan.shade800,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.equals,
                                  size: 16,
                                  color: Colors.cyan.shade800,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '123',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan.shade800,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.plus,
                                  size: 16,
                                  color: Colors.cyan.shade800,
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.minus,
                                  size: 16,
                                  color: Colors.cyan.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botão do jogo de Português ("Letras")
                    SizedBox(
                      width: 160,
                      height: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade700,
                          foregroundColor: Colors.blueGrey.shade100,
                          side: BorderSide(color: Colors.black, width: 2),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
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
                              builder: (context) => JogoPortuguesView(nomeCrianca: widget.nomeCrianca),
                            ),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(width: 8),

                            Center(
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Letras',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan.shade800,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 16,
                                  color: Colors.cyan.shade800,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.pencil,
                                  size: 16,
                                  color: Colors.cyan.shade800,
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: 16,
                                  color: Colors.cyan.shade800,
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.comment,
                                  size: 16,
                                  color: Colors.cyan.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),

                // Botão "Área dos pais": abre a tela protegida por senha de adulto
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    foregroundColor: Colors.blueGrey.shade100,
                    side: BorderSide(color: Colors.black, width: 2),
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 20),
                    textStyle: GoogleFonts.fredoka(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AreaPaisView()),
                    );
                  },
                  child: Text('Área dos pais'),
                ),

                // Spacer ocupa todo o espaço livre, empurrando o rodapé
                Spacer(),
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
