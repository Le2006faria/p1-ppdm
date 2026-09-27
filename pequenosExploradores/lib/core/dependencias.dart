import 'package:get_it/get_it.dart';
import 'package:progrmacao/controller/abertura_app_controller.dart';
import 'package:progrmacao/controller/area_pais_controller.dart';
import 'package:progrmacao/controller/cadastrar_usuario_controller.dart';
import 'package:progrmacao/controller/jogo_matematica_controller.dart';
import 'package:progrmacao/controller/jogo_portugues_controller.dart';
import 'package:progrmacao/controller/login_controller.dart';
import 'package:progrmacao/controller/perfil_controller.dart';
import 'package:progrmacao/controller/principal_controller.dart';
import 'package:progrmacao/controller/recuperar_senha_controller.dart';
import 'package:progrmacao/controller/sobre_controller.dart';

final g = GetIt.instance;

void configurarDependencias(){
  
  g.registerSingleton<AberturaAppController>(AberturaAppController());
  g.registerSingleton<AreaPaisController>(AreaPaisController());
  g.registerSingleton<CadastrarUsuarioController>(CadastrarUsuarioController());
  g.registerSingleton<JogoMatematicaController>(JogoMatematicaController());
  g.registerSingleton<JogoPortuguesController>(JogoPortuguesController());
  g.registerSingleton<LoginController>(LoginController());
  g.registerSingleton<PerfilController>(PerfilController());
  g.registerSingleton<PrincipalController>(PrincipalController());
  g.registerSingleton<RecuperarSenhaController>(RecuperarSenhaController());
  g.registerSingleton<SobreController>(SobreController());

}
