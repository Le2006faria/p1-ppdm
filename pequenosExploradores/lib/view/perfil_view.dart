import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progrmacao/controller/perfil_controller.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  //
  // Associar o Controlador (back) na View (front)
  //
  final ctrl = GetIt.I.get<PerfilController>();

  // false = só exibe as informações | true = nome e filhos editáveis
  bool _editando = false;

  // Controladores dos campos (para preencher e restaurar os textos)
  late final TextEditingController _nomeUsuarioCtrl;
  late final TextEditingController _emailCtrl;
  final List<TextEditingController> _filhosCtrls = [];
  final TextEditingController _novoFilhoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrl.carregarDados(); // sempre abre com os dados iniciais

    _nomeUsuarioCtrl = TextEditingController(text: ctrl.nomeUsuario);
    _emailCtrl = TextEditingController(text: ctrl.email);
    for (final nome in ctrl.nomesFilhos) {
      _filhosCtrls.add(TextEditingController(text: nome));
    }
  }

  @override
  void dispose() {
    _nomeUsuarioCtrl.dispose();
    _emailCtrl.dispose();
    _novoFilhoCtrl.dispose();
    for (final c in _filhosCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // Refaz os campos para ficarem iguais ao que está no controller
  void _reconstruirCampos() {
    _nomeUsuarioCtrl.text = ctrl.nomeUsuario;
    _novoFilhoCtrl.clear();

    final antigos = List<TextEditingController>.from(_filhosCtrls);
    _filhosCtrls
      ..clear()
      ..addAll(
        ctrl.nomesFilhos.map((nome) => TextEditingController(text: nome)),
      );

    // Só descarta os antigos depois que a tela for redesenhada sem eles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in antigos) {
        c.dispose();
      }
    });
  }

  // Adiciona o nome digitado como novo filho (aparece na edição)
  void _adicionarFilho() {
    final nome = _novoFilhoCtrl.text.trim();

    if (nome.isEmpty) {
      _mostrarAlerta('Atenção', 'Digite o nome do filho!');
      return;
    }

    ctrl.adicionarFilho(nome);
    setState(() {
      _filhosCtrls.add(TextEditingController(text: nome));
      _novoFilhoCtrl.clear();
    });
  }

  // Exclui o filho da posição indicada (qualquer um, inclusive os iniciais)
  void _removerFilho(int indice) {
    ctrl.removerFilho(indice);
    final removido = _filhosCtrls.removeAt(indice);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => removido.dispose());
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

  Future<void> _salvar() async {
    // Pop-up caso informação incompleta
    if (!ctrl.dadosCompletos) {
      _mostrarAlerta('Atenção', 'Preencha todas as informações!');
      return;
    }

    // Pop-up de confirmação das alterações
    final bool? confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Confirmar alterações'),
          content: Text('Deseja salvar as alterações do perfil?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false); // só fecha o pop-up
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true); // só fecha o pop-up
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
    if (confirmou != true) return;
    if (!mounted) return;

    // NÃO navega para nenhuma tela: volta para a tela só de exibição,
    // já mostrando o que foi alterado
    ctrl.salvar();
    setState(() {
      _editando = false;
      _novoFilhoCtrl.clear();
    });
  }

  // Informação apenas exibida (fora do modo de edição)
  Widget _campoInfo({required String label, required String valor}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.fredoka(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 2),
          Text(
            valor.isEmpty ? '-' : valor,
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Campo de texto
  Widget _campoTexto({
    required String label,
    required TextEditingController controller,
    Function(String)? onChanged,
    bool somenteLeitura = false,
    String? textoAjuda,
  }) {
    return TextField(
      controller: controller,
      readOnly: somenteLeitura,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: somenteLeitura ? Colors.black54 : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        helperText: textoAjuda,
        // Lápis = pode editar | Cadeado = somente leitura
        suffixIcon: Icon(
          somenteLeitura ? Icons.lock_outline : Icons.edit_outlined,
        ),
        filled: true,
        fillColor: somenteLeitura
            ? Colors.blueGrey.shade300
            : Colors.blueGrey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }

  // Conteúdo da caixa de filhos: exibição ou edição
  Widget _listaFilhos() {
    if (_filhosCtrls.isEmpty) {
      return Text(
        'Nenhum filho cadastrado',
        style: GoogleFonts.fredoka(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < _filhosCtrls.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == _filhosCtrls.length - 1 ? 0 : 10,
              ),
              child: _editando
                  ? Row(
                      children: [
                        Expanded(
                          child: _campoTexto(
                            label: 'Nome do ${i + 1}º filho',
                            controller: _filhosCtrls[i],
                            onChanged: (valor) {
                              ctrl.setNomeFilho(i, valor);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removerFilho(i),
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red.shade800,
                          tooltip: 'Excluir',
                        ),
                      ],
                    )
                  : _campoInfo(
                      label: '${i + 1}º filho',
                      valor: ctrl.nomesFilhos[i],
                    ),
            ),
        ],
      ),
    );
  }

  // Campo para digitar o nome de um novo filho + botão de adicionar
  Widget _campoNovoFilho() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _novoFilhoCtrl,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _adicionarFilho(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              labelText: 'Novo filho',
              filled: true,
              fillColor: Colors.blueGrey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan.shade700,
            foregroundColor: Colors.blueGrey.shade100,
            side: BorderSide(color: Colors.black, width: 2),
            minimumSize: Size(56, 56),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          onPressed: _adicionarFilho,
          child: Icon(Icons.add, size: 30),
        ),
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
                        Navigator.pop(context); // volta para a Área dos Pais
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

                SizedBox(height: 15),

                // Parte rolável da tela
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.black,
                            size: 56,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Meu Perfil',
                          style: GoogleFonts.fredoka(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: 15),

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
                                // Nome do usuário
                                _editando
                                    ? _campoTexto(
                                        label: 'Nome do usuário',
                                        controller: _nomeUsuarioCtrl,
                                        onChanged: (valor) {
                                          ctrl.setNomeUsuario(valor);
                                        },
                                      )
                                    : _campoInfo(
                                        label: 'Nome do usuário',
                                        valor: ctrl.nomeUsuario,
                                      ),

                                SizedBox(height: 20),
                                Text(
                                  'Filhos',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),

                                // Lista de todos os filhos
                                Container(
                                  width: double.infinity,
                                  constraints: BoxConstraints(maxHeight: 230),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: _listaFilhos(),
                                ),

                                // Adicionar filho (só durante a edição)
                                if (_editando) ...[
                                  SizedBox(height: 10),
                                  _campoNovoFilho(),
                                ],

                                SizedBox(height: 20),

                                // E-mail: nunca pode ser alterado
                                _editando
                                    ? _campoTexto(
                                        label: 'E-mail',
                                        controller: _emailCtrl,
                                        somenteLeitura: true,
                                        textoAjuda:
                                            'O e-mail não pode ser alterado',
                                      )
                                    : _campoInfo(
                                        label: 'E-mail',
                                        valor: ctrl.email,
                                      ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        if (!_editando)
                          // Fora da edição: só o botão Editar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan.shade700,
                                foregroundColor: Colors.blueGrey.shade100,
                                side: BorderSide(color: Colors.black, width: 2),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                textStyle: GoogleFonts.fredoka(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _editando = true;
                                });
                              },
                              child: Text('Editar'),
                            ),
                          )
                        else ...[
                          // Em edição: Salvar alterações e Cancelar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan.shade700,
                                foregroundColor: Colors.blueGrey.shade100,
                                side: BorderSide(color: Colors.black, width: 2),
                                padding: EdgeInsets.symmetric(vertical: 16),
                                textStyle: GoogleFonts.fredoka(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _salvar,
                              child: Text('Salvar alterações'),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              // Descarta o que foi mexido (nome, filhos
                              // excluídos e adicionados)
                              ctrl.cancelar();
                              _reconstruirCampos();
                              setState(() {
                                _editando = false;
                              });
                            },
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey.shade700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],

                        SizedBox(height: 10),
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