import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_car/autenticador.dart';
import 'package:s_car/componentes/cartao_carro.dart';
import 'package:s_car/gerenciador_estado.dart';
import 'package:s_car/usuario.dart';
import 'package:toast/toast.dart';

class Carros extends StatefulWidget {
  const Carros({super.key});

  @override
  State<StatefulWidget> createState() => _CarrosState();
}

class _CarrosState extends State<Carros> {
  List<dynamic> _todosCarros = [];
  List<dynamic> _carros = [];
  bool _carregandoCarros = false;

  final TextEditingController _controladorFiltro = TextEditingController();

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _controladorFiltro.text = estadoApp.filtro;

    _carregarCarros();
  }

  @override
  void dispose() {
    _controladorFiltro.dispose();

    super.dispose();
  }

  Future<List<dynamic>> _acessarCarros() async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/carros.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    // As notas médias exibidas nos cartões vêm dos comentários.
    await estadoApp.carregarComentarios();

    return dicionario["carros"];
  }

  // Remove acentos e maiúsculas para a pesquisa ("opala" acha "Ópala").
  String _normalizar(String texto) {
    const comAcento = "áàâãäéèêëíìîïóòôõöúùûüçñ";
    const semAcento = "aaaaaeeeeiiiiooooouuuucn";

    String resultado = texto.toLowerCase();
    for (int i = 0; i < comAcento.length; i++) {
      resultado = resultado.replaceAll(comAcento[i], semAcento[i]);
    }

    return resultado.trim();
  }

  // Pesquisa por marca, modelo ou ano. Todas as palavras digitadas devem existir.
  List<dynamic> _filtrar(List<dynamic> carros, String filtro) {
    final List<String> palavras = _normalizar(
      filtro,
    ).split(" ").where((p) => p.isNotEmpty).toList();

    if (palavras.isEmpty) {
      return List<dynamic>.from(carros);
    }

    return carros.where((c) {
      final String texto = _normalizar(
        "${c["brand"]["name"]} ${c["car"]["name"]} ${c["car"]["year"]}",
      );

      return palavras.every((palavra) => texto.contains(palavra));
    }).toList();
  }

  void _carregarCarros() {
    setState(() {
      _carregandoCarros = true;
    });

    _acessarCarros().then((carros) {
      if (!mounted) {
        return;
      }

      setState(() {
        _todosCarros = carros;
        _carros = _filtrar(_todosCarros, estadoApp.filtro);

        _carregandoCarros = false;
      });
    });
  }

  Future<void> _atualizarCarros() async {
    _controladorFiltro.text = "";
    estadoApp.filtro = "";

    _carregarCarros();
  }

  void _aplicarFiltro(String filtro) {
    estadoApp.filtro = filtro;

    setState(() {
      _carros = _filtrar(_todosCarros, filtro);
    });
  }

  Widget _exibirMensagemCarrosInexistentes() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 120),
        Icon(Icons.search_off, size: 40, color: Colors.black45),
        SizedBox(height: 8),
        Center(
          child: Text("nenhum carro encontrado", style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _exibirCarros() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisExtent: 285,
      ),
      itemCount: _carros.length,
      itemBuilder: (context, index) {
        return CartaoCarro(carro: _carros[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset("recursos/imagens/avatar.png"),
        ),
        title: SizedBox(
          height: 42,
          child: TextField(
            controller: _controladorFiltro,
            onChanged: _aplicarFiltro,
            onSubmitted: _aplicarFiltro,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Buscar marca ou modelo...",
              hintStyle: const TextStyle(fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: const OutlineInputBorder(),
              suffixIcon: _controladorFiltro.text.isEmpty
                  ? const Icon(Icons.search)
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controladorFiltro.clear();
                        _aplicarFiltro("");
                      },
                    ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: estadoApp.usuario != null
                ? IconButton(
                    tooltip: "Sair",
                    onPressed: () {
                      Autenticador.logout().then((_) {
                        setState(() {
                          estadoApp.logout();
                        });

                        Toast.show(
                          "Você foi desconectado com sucesso",
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                        );
                      });
                    },
                    icon: const Icon(Icons.logout),
                  )
                : IconButton(
                    tooltip: "Entrar",
                    onPressed: () {
                      Autenticador.login().then((Usuario? usuario) {
                        setState(() {
                          estadoApp.login(usuario);
                        });

                        Toast.show(
                          "Você foi conectado com sucesso",
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                        );
                      });
                    },
                    icon: const Icon(Icons.login),
                  ),
          ),
        ],
      ),
      body: _carregandoCarros
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: Colors.red,
              onRefresh: () => _atualizarCarros(),
              child: _carros.isEmpty
                  ? _exibirMensagemCarrosInexistentes()
                  : _exibirCarros(),
            ),
    );
  }
}
