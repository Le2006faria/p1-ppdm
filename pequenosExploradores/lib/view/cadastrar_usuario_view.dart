import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/cadastrar_usuario_controller.dart';
import 'package:progrmacao/view/login_view.dart';

class CadastrarUsuarioView extends StatefulWidget {
  const CadastrarUsuarioView({super.key});

  @override
  State<CadastrarUsuarioView> createState() => _CadastrarUsuarioViewState();
}

class _CadastrarUsuarioViewState extends State<CadastrarUsuarioView> {
  //
  // Associar o Controlador (back) na View (front)
  //
  final ctrl = GetIt.I.get<CadastrarUsuarioController>();

  // Focos para validar o campo quando o usuário troca de campo
  final FocusNode _focoEmail = FocusNode();
  final FocusNode _focoConfirmarSenha = FocusNode();

  void _atualizar() => setState(() {});

  @override
  void initState() {
    super.initState();
    ctrl.addListener(_atualizar);

    // Valida o e-mail ao sair do campo
    _focoEmail.addListener(() {
      if (!_focoEmail.hasFocus &&
          ctrl.email.isNotEmpty &&
          !_emailValido(ctrl.email)) {
        _mostrarAlerta('E-mail inválido', 'Informe um e-mail válido!');
      }
    });

    // Valida a confirmação de senha ao sair do campo
    _focoConfirmarSenha.addListener(() {
      if (!_focoConfirmarSenha.hasFocus &&
          ctrl.confirmarSenha.isNotEmpty &&
          ctrl.senha != ctrl.confirmarSenha) {
        _mostrarAlerta('Senhas diferentes', 'As senhas não coincidem!');
      }
    });
  }

  @override
  void dispose() {
    ctrl.removeListener(_atualizar);
    _focoEmail.dispose();
    _focoConfirmarSenha.dispose();
    super.dispose();
  }

  // O e-mail precisa ter @ e .com
  bool _emailValido(String email) {
    return email.contains('@') && email.contains('.com');
  }

  void _mostrarAlerta(String titulo, String mensagem) {
    if (!mounted) return;
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

  void _cadastrar() {
    try {
      // Pop-up caso falte informação
      if (ctrl.nomeCompleto.trim().isEmpty ||
          ctrl.nomeUsuario.trim().isEmpty ||
          ctrl.email.trim().isEmpty ||
          ctrl.telefone.trim().isEmpty ||
          ctrl.senha.isEmpty ||
          ctrl.confirmarSenha.isEmpty ||
          ctrl.quantidadeFilhos == 0 ||
          ctrl.nomesFilhos.any((nome) => nome.trim().isEmpty)) {
        _mostrarAlerta('Atenção', 'Preencha todos os campos!');
        return;
      }

      // Pop-up caso e-mail inválido
      if (!_emailValido(ctrl.email)) {
        _mostrarAlerta('E-mail inválido', 'Informe um e-mail válido!');
        return;
      }

      // Telefone completo: (00)00000-0000
      if (ctrl.telefone.length != 14) {
        _mostrarAlerta('Telefone inválido', 'Informe o telefone completo!');
        return;
      }

      // Pop-up caso senhas diferentes
      if (ctrl.senha != ctrl.confirmarSenha) {
        _mostrarAlerta('Senhas diferentes', 'As senhas não coincidem!');
        return;
      }

      // Cadastro ok -> volta para o Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } catch (e) {
      // Pop-up caso erro
      _mostrarAlerta('Erro', 'Ocorreu um erro ao cadastrar. Tente novamente!');
    }
  }

  // Campo de texto padrão da tela
  Widget _campoTexto({
    required String label,
    required Function(String) onChanged,
    Key? key,
    FocusNode? focusNode,
    TextInputType? teclado,
    List<TextInputFormatter>? formatadores,
    bool senha = false,
  }) {
    return TextField(
      key: key,
      focusNode: focusNode,
      keyboardType: teclado,
      inputFormatters: formatadores,
      obscureText: senha,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blueGrey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
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
                        Navigator.pop(context); // volta para o Login
                      },
                      child: Text('<'),
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
                          'Cadastro de Usuário',
                          style: GoogleFonts.fredoka(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Preencha os dados para criar sua conta',
                          style: GoogleFonts.fredoka(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: 20),

                        Card(
                          color: Colors.blueGrey.shade100,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Tipo de Perfil - ',
                                    children: [
                                      TextSpan(
                                        text: 'Parental',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: GoogleFonts.fredoka(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                SizedBox(height: 15),
                                _campoTexto(
                                  label: 'Nome completo',
                                  teclado: TextInputType.name,
                                  onChanged: (valor) {
                                    ctrl.setNomeCompleto(valor);
                                  },
                                ),

                                SizedBox(height: 15),
                                _campoTexto(
                                  label: 'Nome do usuário',
                                  onChanged: (valor) {
                                    ctrl.setNomeUsuario(valor);
                                  },
                                ),

                                SizedBox(height: 15),
                                _campoTexto(
                                  label: 'E-mail',
                                  focusNode: _focoEmail,
                                  teclado: TextInputType.emailAddress,
                                  onChanged: (valor) {
                                    ctrl.setEmail(valor);
                                  },
                                ),

                                SizedBox(height: 15),
                                _campoTexto(
                                  label: 'Telefone',
                                  teclado: TextInputType.phone,
                                  formatadores: [TelefoneFormatter()],
                                  onChanged: (valor) {
                                    ctrl.setTelefone(valor);
                                  },
                                ),

                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _campoTexto(
                                        label: 'Senha',
                                        senha: true,
                                        onChanged: (valor) {
                                          ctrl.setSenha(valor);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: _campoTexto(
                                        label: 'Valida Senha',
                                        senha: true,
                                        focusNode: _focoConfirmarSenha,
                                        onChanged: (valor) {
                                          ctrl.setConfirmarSenha(valor);
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 25),
                                Text.rich(
                                  TextSpan(
                                    text: 'Tipo de Perfil - ',
                                    children: [
                                      TextSpan(
                                        text: 'Infantil',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: GoogleFonts.fredoka(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(
                                          'Quantidade de filhos',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      child: DropdownButton<int>(
                                        value: ctrl.quantidadeFilhos == 0
                                            ? null
                                            : ctrl.quantidadeFilhos,
                                        hint: Text(
                                          'Selecione',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        underline: SizedBox(),
                                        style: GoogleFonts.fredoka(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        items: [1, 2, 3, 4, 5].map((qtd) {
                                          return DropdownMenuItem<int>(
                                            value: qtd,
                                            child: Text('$qtd'),
                                          );
                                        }).toList(),
                                        onChanged: (valor) {
                                          if (valor != null) {
                                            ctrl.setQuantidadeFilhos(valor);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // Um campo de nome para cada filho
                                for (int i = 0; i < ctrl.quantidadeFilhos; i++)
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: _campoTexto(
                                      key: ValueKey('filho$i'),
                                      label: 'Nome do ${i + 1}º filho',
                                      onChanged: (valor) {
                                        ctrl.setNomeFilho(i, valor);
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan.shade700,
                              foregroundColor: Colors.blueGrey.shade100,
                              side: BorderSide(color: Colors.black, width: 2),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              textStyle: GoogleFonts.fredoka(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _cadastrar,
                            child: Text('Cadastrar'),
                          ),
                        ),

                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),

                Text(
                  '© 2026 Pequenos Exploradores - Todos os Direitos Reservados',
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
// Formatador do telefone: (00)00000-0000
//
class TelefoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Mantém só os números
    String digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitos.length > 11) {
      digitos = digitos.substring(0, 11);
    }

    String texto = '';
    for (int i = 0; i < digitos.length; i++) {
      if (i == 0) texto += '(';
      if (i == 2) texto += ')';
      if (i == 7) texto += '-';
      texto += digitos[i];
    }

    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}