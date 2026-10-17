import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_car/autenticador.dart';
import 'package:s_car/componentes/avatar_marca.dart';
import 'package:s_car/componentes/cartao_comentario.dart';
import 'package:s_car/componentes/cartao_detalhes_carro.dart';
import 'package:s_car/componentes/controles_usuario.dart';
import 'package:s_car/componentes/imagem_carro.dart';
import 'package:s_car/componentes/seletor_nota.dart';
import 'package:s_car/gerenciador_estado.dart';
import 'package:s_car/usuario.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:toast/toast.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetalhesState();
  }
}

class _DetalhesState extends State<Detalhes> {
  dynamic _carro;

  bool _carregandoComentarios = false;

  // Nota (1 a 10) que o usuário logado está escolhendo para o novo comentário.
  int? _notaSelecionada;

  final TextEditingController _controladorNovoComentario =
      TextEditingController();

  late PageController _controladorSlides;
  late int _slideSelecionado;

  // Velocidade usada como "fundo de escala" na barra do segundo slide.
  static const double _velocidadeReferencia = 420;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _iniciarSlides();
    _carregarCarro();
    _carregarComentarios();
  }

  @override
  void dispose() {
    _controladorNovoComentario.dispose();
    _controladorSlides.dispose();

    super.dispose();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _controladorSlides = PageController(initialPage: _slideSelecionado);
  }

  Future<dynamic> _acessarCarro(int idCarro) async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/carros.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    final carro = dicionario["carros"].firstWhere((c) => c["_id"] == idCarro);

    return carro;
  }

  void _carregarCarro() {
    _acessarCarro(estadoApp.idCarro).then((carro) {
      if (!mounted) {
        return;
      }

      setState(() {
        _carro = carro;
      });
    });
  }

  void _carregarComentarios() {
    setState(() {
      _carregandoComentarios = true;
    });

    estadoApp.carregarComentarios().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _carregandoComentarios = false;
      });
    });
  }

  Widget _exibirMensagemComentariosInexistentes() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.comment, size: 26),
          Text("não existem comentários", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _exibirComentario(dynamic comentario) {
    bool usuarioLogadoComentou =
        estadoApp.usuario != null &&
        estadoApp.usuario!.email == comentario["user"]["email"];

    return Dismissible(
      key: ValueKey(comentario["_id"]),
      direction: usuarioLogadoComentou
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Icon(Icons.delete, color: Colors.red),
        ),
      ),
      child: CartaoComentario(
        comentario: comentario,
        somenteLeitura: !usuarioLogadoComentou,
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Deseja apagar o comentário?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("NÃO"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("SIM"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        setState(() {
          estadoApp.removerComentario(comentario["_id"]);
        });
      },
    );
  }

  void _adicionarComentario() {
    final String conteudo = _controladorNovoComentario.text.trim();

    if (_notaSelecionada == null) {
      Toast.show(
        "escolha uma nota de 1 a 10",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );
      return;
    }

    if (conteudo.isEmpty) {
      Toast.show(
        "digite seu comentário",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      estadoApp.adicionarComentario(_carro["_id"], conteudo, _notaSelecionada!);

      _controladorNovoComentario.clear();
      _notaSelecionada = null;
    });

    Toast.show(
      "comentário e nota adicionados",
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
    );
  }

  // Formulário exibido somente para usuário logado.
  Widget _exibirFormularioComentario() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _notaSelecionada == null
                  ? "Sua nota (1 a 10)"
                  : "Sua nota: $_notaSelecionada",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            SeletorNota(
              notaSelecionada: _notaSelecionada,
              onSelecionou: (nota) {
                setState(() {
                  _notaSelecionada = nota;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controladorNovoComentario,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 0.0),
                ),
                border: const OutlineInputBorder(),
                hintStyle: const TextStyle(fontSize: 14),
                hintText: 'Digite aqui seu comentário...',
                suffixIcon: GestureDetector(
                  onTap: _adicionarComentario,
                  child: const Icon(Icons.send, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Aviso exibido para quem ainda não está logado.
  Widget _exibirAvisoLogin() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "Entre para comentar e dar uma nota ao carro.",
                style: TextStyle(fontSize: 13),
              ),
            ),
            TextButton(
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
              child: const Text("ENTRAR"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _painelEscuro({required List<Widget> filhos}) {
    final Color cor = AvatarMarca.converterCor(_carro["brand"]["color"]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(cor, Colors.black, 0.35)!,
            Color.lerp(cor, Colors.black, 0.8)!,
          ],
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: filhos),
    );
  }

  Widget _exibirSlide(int posicao) {
    final dynamic dados = _carro["car"];

    if (posicao == 0) {
      return ImagemCarro(arquivo: dados["blobs"][0]["file"]);
    }

    if (posicao == 1) {
      final double proporcao = ((dados["topSpeed"] as num) /
              _velocidadeReferencia)
          .clamp(0.0, 1.0)
          .toDouble();

      return _painelEscuro(
        filhos: [
          const Icon(Icons.speed, color: Colors.white70, size: 34),
          Text(
            "${dados["topSpeed"]}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "km/h de velocidade máxima",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: proporcao,
              minHeight: 10,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      );
    }

    return _painelEscuro(
      filhos: [
        const Icon(Icons.bolt, color: Colors.white70, size: 34),
        const SizedBox(height: 6),
        Text(
          dados["performance"],
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 14),
        Text(
          "Ano de fabricação: ${dados["year"]}",
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _exibirCarro() {
    bool usuarioLogado = estadoApp.usuario != null;
    final List<dynamic> comentarios = estadoApp.comentariosDoCarro(
      _carro["_id"],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: "Voltar",
          onPressed: () {
            estadoApp.exibirCarros();
          },
          icon: const Icon(Icons.arrow_back, size: 28),
        ),
        title: Row(
          children: [
            AvatarMarca(marca: _carro["brand"], raio: 16),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  _carro["brand"]["name"],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          SizedBox(
            height: 230,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: 3,
                  controller: _controladorSlides,
                  onPageChanged: (slide) {
                    setState(() {
                      _slideSelecionado = slide;
                    });
                  },
                  itemBuilder: (context, pagePosition) {
                    return _exibirSlide(pagePosition);
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ControlesUsuario(carro: _carro),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: PageViewDotIndicator(
              currentItem: _slideSelecionado,
              count: 3,
              unselectedColor: Colors.black26,
              selectedColor: Colors.red,
              duration: const Duration(milliseconds: 200),
              boxShape: BoxShape.circle,
            ),
          ),
          CartaoDetalhesCarro(carro: _carro),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: Text(
                "Comentários e notas",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          usuarioLogado ? _exibirFormularioComentario() : _exibirAvisoLogin(),
          if (_carregandoComentarios)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (comentarios.isEmpty)
            _exibirMensagemComentariosInexistentes()
          else
            ...comentarios.map(_exibirComentario),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget detalhes = SizedBox.expand(
      child: Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    if (_carro != null) {
      detalhes = _exibirCarro();
    }

    return detalhes;
  }
}
