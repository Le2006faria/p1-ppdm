import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/login_controller.dart';
import 'package:progrmacao/view/abertura_app_view.dart';
import 'package:progrmacao/view/cadastrar_usuario_view.dart';
import 'package:progrmacao/view/principal_view.dart';
import 'package:progrmacao/view/recuperar_senha_view.dart';

// Tela de login do app
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //
  // Associar o Controlador (back) na View (front)
  //
  final ctrl = GetIt.I.get<LoginController>();

  void _atualizar() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ctrl.addListener(_atualizar);
  }

  @override
  void dispose() {
    ctrl.removeListener(_atualizar);
    super.dispose();
  }

  void _mostrarAlerta(String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Pop-up com os filhos cadastrados pelo responsável (lidos do Firestore
  // depois do login). Retorna o nome escolhido ou null se cancelar.
  Future<String?> _escolherFilho() async {
    if (ctrl.filhos.isEmpty) return 'Criança';
    if (ctrl.filhos.length == 1) return ctrl.filhos.first;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text('Quem vai jogar?'),
          children: [
            for (final nome in ctrl.filhos)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, nome),
                child: Text(nome, style: TextStyle(fontSize: 20)),
              ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Valida os campos, autentica no Firebase e abre a tela principal
  Future<void> _entrar() async {
    if (ctrl.email.trim().isEmpty || ctrl.senha.isEmpty) {
      _mostrarAlerta('Informe o email e a senha!');
      return;
    }
    if (!ctrl.emailValido) {
      _mostrarAlerta('Digite um email válido!');
      return;
    }

    final erro = await ctrl.login();
    if (!mounted) return;

    if (erro != null) {
      _mostrarAlerta(erro);
      return;
    }

    final filho = await _escolherFilho();
    if (!mounted) return;

    if (filho == null) {
      // Cancelou a escolha: encerra a sessão
      await ctrl.logout();
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PrincipalView(nomeCrianca: filho)),
    );
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
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                // Barra superior: botão de voltar + selo com o nome do app
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AberturaAppView(),
                          ),
                        );
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

                // Cabeçalho: ícone de usuário + título + subtítulo
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Text(
                      'Entrar',
                      style: GoogleFonts.fredoka(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Acesse sua conta para continuar',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Formulário (dentro de um Card): email e senha
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
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
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

                        SizedBox(height: 15),

                        // Campo de senha
                        TextField(
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            filled: true,
                            fillColor: Colors.blueGrey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (valor) {
                            ctrl.setSenha(valor);
                          },
                        ),

                        // Link para a tela de recuperação de senha
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecuperarSenhaView(),
                              ),
                            );
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 35),

                // Botão de acesso: valida os campos e entra no app
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade700,
                    foregroundColor: Colors.blueGrey.shade100,
                    side: BorderSide(color: Colors.black, width: 2),
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                    textStyle: GoogleFonts.fredoka(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: ctrl.carregando ? null : _entrar,
                  child: ctrl.carregando
                      ? SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : Text('Acessar'),
                ),

                // Link para a tela de cadastro de novo usuário
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastrarUsuarioView(),
                      ),
                    );
                  },
                  child: Text(
                    'Ainda não tem conta? Cadastre-se',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade700,
                      decoration: TextDecoration
                          .underline, // opcional, deixa parecendo link
                    ),
                  ),
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
