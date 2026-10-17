import 'package:flutter/material.dart';
import 'package:s_car/gerenciador_estado.dart';
import 'package:s_car/telas/carros.dart';
import 'package:s_car/telas/detalhes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SCar());
}

class SCar extends StatelessWidget {
  const SCar({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GerenciadorEstado(),
      child: MaterialApp(
        title: 'S-Car',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade800),
        ),
        home: const TelaPrincipal(),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    estadoApp = context.watch<GerenciadorEstado>();

    Widget tela = const SizedBox.shrink();
    if (estadoApp.exibicao == EmExibicao.telaCarros) {
      // ignore: prefer_const_constructors
      tela = Carros();
    } else if (estadoApp.exibicao == EmExibicao.telaDetalhes) {
      // ignore: prefer_const_constructors
      tela = Detalhes();
    }

    // O botão "voltar" do celular retorna da tela de detalhes para a lista.
    return PopScope(
      canPop: estadoApp.exibicao == EmExibicao.telaCarros,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          estadoApp.exibirCarros();
        }
      },
      child: tela,
    );
  }
}
