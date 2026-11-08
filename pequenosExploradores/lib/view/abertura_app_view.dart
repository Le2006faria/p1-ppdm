import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/view/login_view.dart';
import 'package:progrmacao/view/sobre_view.dart';

// Tela inicial do app "Pequenos Exploradores"
class AberturaAppView extends StatefulWidget {
  const AberturaAppView({super.key});

  @override
  State<AberturaAppView> createState() => _AberturaAppViewState();
}

class _AberturaAppViewState extends State<AberturaAppView> {

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
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.cubes,
                          color: Colors.cyan,
                          size: 50,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Pequenos',
                          style: GoogleFonts.fredoka(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Exploradores',
                      style: GoogleFonts.fredoka(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Um mundo de jogos para aprender brincando',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 110),

                //
                // Botão
                //
                SizedBox(height: 15),

                // Botão "Começar": leva o usuário para a tela de Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    foregroundColor: Colors.blueGrey.shade100,
                    side: BorderSide(color: Colors.black, width: 2),
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                    textStyle: GoogleFonts.fredoka(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: Text('Começar'),
                ),

                SizedBox(height: 30),

                // Botão "Tutorial": leva o usuário para a tela Sobre
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    foregroundColor: Colors.blueGrey.shade100,
                    side: BorderSide(color: Colors.black, width: 2),
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                    textStyle: GoogleFonts.fredoka(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SobreView()),
                    );
                  },
                  child: Text('Tutorial'),
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
