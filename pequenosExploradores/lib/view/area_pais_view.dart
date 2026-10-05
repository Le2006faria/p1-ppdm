import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/area_pais_controller.dart';
import 'package:progrmacao/view/perfil_view.dart';
import 'package:progrmacao/view/recuperar_senha_view.dart';

class AreaPaisView extends StatefulWidget {
  const AreaPaisView({super.key});

  @override
  State<AreaPaisView> createState() => _AreaPaisViewState();
}

class _AreaPaisViewState extends State<AreaPaisView> {
  final ctrl = GetIt.I.get<AreaPaisController>();
  final String nomeResponsavel = 'Maria Silva';
  final List<String> nomeCrianca = ['Ana', 'João', 'José'];
  double limiteDiario = 60;
  double mediaDiaria = 90;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarPopupResponsavel();
    });
  }

  void _mostrarPopupResponsavel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Espaço dos responsáveis',
            style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Peça para um adulto digitar a senha para continuar até a recuperação de senha.',
                style: GoogleFonts.fredoka(),
              ),
              SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha do adulto',
                  filled: true,
                  fillColor: Colors.blueGrey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fecha o pop-up
                Navigator.pop(context); // volta para o login
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context); // libera a tela
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
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
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Navigator.pop(context);
                      },
                      child: Text('>'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Área dos Pais',
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
                      'Controle de conta e resumo geral',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                //
                // Botão
                //
                SizedBox(height: 30),

                _CardMoldura(
                  child: _TempoSlider(
                    titulo: 'Controle de tempo de uso diário',
                    valor: limiteDiario,
                    onChanged: (v) => setState(() => limiteDiario = v),
                  ),
                ),

                SizedBox(height: 10),

                _CardMoldura(
                  child: _TempoSlider(
                    titulo: 'Média de uso diário',
                    valor: mediaDiaria,
                    onChanged: (v) => setState(() => mediaDiaria = v),
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.cyan.shade700,
                    foregroundColor: Colors.blueGrey.shade100,
                    side: BorderSide(color: Colors.black, width: 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 10,
                    ),
                    textStyle: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PerfilView()),
                    );
                  },
                  child: Text('Meu Perfil'),
                ),

                SizedBox(height: 15),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.cyan.shade700,
                    foregroundColor: Colors.blueGrey.shade100,
                    side: BorderSide(color: Colors.black, width: 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: 105,
                      vertical: 10,
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
                        builder: (context) => RecuperarSenhaView(),
                      ),
                    );
                  },
                  child: Text('Alterar Senha'),
                ),

                SizedBox(height: 25),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.person_rounded,
                          titulo: 'Responsável',
                          child: Text(
                            nomeResponsavel,
                            style: GoogleFonts.fredoka(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.child_care_rounded,
                          titulo: 'Criança',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: nomeCrianca
                                .map(
                                  (nome) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      '• $nome',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.titulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.cyan.shade700, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatarTempo(double minutos) {
  final h = minutos ~/ 60;
  final m = (minutos % 60).round();
  if (h == 0) return '${m}min';
  if (m == 0) return '${h}h';
  return '${h}h${m}min';
}

class _TempoSlider extends StatelessWidget {
  final String titulo;
  final double valor;
  final ValueChanged<double>? onChanged;

  const _TempoSlider({
    required this.titulo,
    required this.valor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final estiloLabel = GoogleFonts.fredoka(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final slider = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 18,
          margin: EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 12,
            tickMarkShape: SliderTickMarkShape.noTickMark,
            activeTrackColor: Colors.cyan.shade700,
            inactiveTrackColor: Colors.transparent,
            thumbColor: Colors.black,
            overlayColor: Colors.black12,
          ),
          child: Slider(
            value: valor,
            min: 30,
            max: 150,
            divisions: 24,
            onChanged: onChanged ?? (_) {},
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Icon(Icons.access_time_rounded, color: Colors.black),
          ],
        ),
        onChanged == null ? IgnorePointer(child: slider) : slider,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('30min', style: estiloLabel),
              Text('1h', style: estiloLabel),
              Text('2h30min', style: estiloLabel),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardMoldura extends StatelessWidget {
  final Widget child;

  const _CardMoldura({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: child,
    );
  }
}
