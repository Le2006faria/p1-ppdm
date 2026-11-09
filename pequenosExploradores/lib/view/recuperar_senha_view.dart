import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/recuperar_senha_controller.dart';

class RecuperarSenhaView extends StatefulWidget {
  final bool exigirPin;
  const RecuperarSenhaView({super.key, this.exigirPin = true});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  //
  // Associar o Controlador (back) na View (front)
  //
  final ctrl = GetIt.I.get<RecuperarSenhaController>();

  void _atualizar() => setState(() {});

  @override
  void initState() {
    super.initState();
    ctrl.addListener(_atualizar);

    // Só pede o PIN quando a tela é aberta pelo login
    if (widget.exigirPin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarPopupResponsavel();
      });
    }
  }

  @override
  void dispose() {
    ctrl.removeListener(_atualizar);
    super.dispose();
  }

  void _mostrarPopupResponsavel() {
    final pinCtrl = TextEditingController();
    ctrl.limparMensagemErro();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ListenableBuilder(
          listenable: ctrl,
          builder: (_, __) => AlertDialog(
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
                  'Um adulto digitar o PIN para recuperar a senha.',
                  style: GoogleFonts.fredoka(),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: pinCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'PIN do responsável',
                    counterText: '',
                    errorText: ctrl.mensagemErro,
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
                  Navigator.pop(dialogContext); // fecha o pop-up
                  Navigator.pop(context); // volta para a tela anterior
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final ok = await ctrl.validarPin(pinCtrl.text);
                  if (ok && dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text('Confirmar'),
              ),
            ],
          ),
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
                        // Retorna à página anterior (login)
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

                SizedBox(height: 50),

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Recuperar Senha',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Informe um e-mail cadastrado para receber\nas informações de redefinição',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 35),

                Card(
                  color: Colors.blueGrey.shade100,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(20),
                    child: Column(
                      children: [
                        TextField(
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            filled: true,
                            fillColor: Colors.blueGrey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (valor) {
                            ctrl.setEmail(valor);
                          },
                        ),

                        SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan.shade700,
                              foregroundColor: Colors.blueGrey.shade100,
                              side: BorderSide(color: Colors.black, width: 2),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: GoogleFonts.fredoka(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: ctrl.carregando
                                ? null
                                : () async {
                                    final ok = await ctrl.enviarInstrucoes();
                                    if (!context.mounted) return;

                                    if (ok) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          title: Text(
                                            'Instruções enviadas!',
                                            style: GoogleFonts.fredoka(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            'Se o e-mail estiver cadastrado, você receberá as instruções na caixa de entrada (confira o spam).',
                                            style: GoogleFonts.fredoka(),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.cyan.shade700,
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(
                                                  context,
                                                ); // fecha o pop-up
                                                Navigator.pop(
                                                  context,
                                                ); // volta para a tela anterior
                                              },
                                              child: Text('Ok, entendi'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Atenção'),
                                          content: Text(
                                            ctrl.mensagemErro ??
                                                'Erro ao enviar.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                            child: Text(
                              ctrl.carregando
                                  ? 'Enviando...'
                                  : 'Enviar Instruções',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Voltar para o login',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade700,
                      decoration: TextDecoration.underline,
                    ),
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
