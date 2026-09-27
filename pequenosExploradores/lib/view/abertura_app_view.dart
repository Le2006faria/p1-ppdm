import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:progrmacao/controller/abertura_app_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/view/login_view.dart';
import 'package:progrmacao/view/sobre_view.dart';

class AberturaAppView extends StatefulWidget {
  const AberturaAppView({super.key});

  @override
  State<AberturaAppView> createState() => _AberturaAppViewState();
}

class _AberturaAppViewState extends State<AberturaAppView> {
  //
  // Associar o Controlador (back) na View (front)
  //
  final ctrl = GetIt.I.get<AberturaAppController>();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
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
