import 'package:flutter/material.dart';

class JogoMatematicaView extends StatefulWidget {
  final String nomeCrianca;
  const JogoMatematicaView({super.key, this.nomeCrianca = 'Criança'});

  @override
  State<JogoMatematicaView> createState() => _JogoMatematicaViewState();
}

class _JogoMatematicaViewState extends State<JogoMatematicaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        ),
      );
  }
}
