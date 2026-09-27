import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:progrmacao/core/app_routes.dart';
import 'package:progrmacao/core/dependencias.dart';
import 'package:progrmacao/view/abertura_app_view.dart';
import 'package:progrmacao/view/area_pais_view.dart';
import 'package:progrmacao/view/cadastrar_usuario_view.dart';
import 'package:progrmacao/view/jogo_matematica_view.dart';
import 'package:progrmacao/view/jogo_portugues_view.dart';
import 'package:progrmacao/view/login_view.dart';
import 'package:progrmacao/view/perfil_view.dart';
import 'package:progrmacao/view/principal_view.dart';
import 'package:progrmacao/view/recuperar_senha_view.dart';
import 'package:progrmacao/view/sobre_view.dart';

void main(){
  configurarDependencias();

  runApp(
    DevicePreview(
      builder: (context) => MainApp()),
  );
  
}

class MainApp extends StatelessWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      initialRoute: AppRoutes.aberturaApp,
      routes: {
        AppRoutes.aberturaApp:(context) => const AberturaAppView(),
        AppRoutes.areaPais:(context) => const AreaPaisView(),
        AppRoutes.cadastrarUsuario:(context) => const CadastrarUsuarioView(),
        AppRoutes.jogoMatematica:(context) => const JogoMatematicaView(),
        AppRoutes.jogoPortugues:(context) => const JogoPortuguesView(),
        AppRoutes.login:(context) => const LoginView(),
        AppRoutes.perfil:(context) => const PerfilView(),
        AppRoutes.principal:(context) => const PrincipalView(),
        AppRoutes.recuperarSenha:(context) => const RecuperarSenhaView(),
        AppRoutes.sobre:(context) => const SobreView(),
      },
    );
  }
}
