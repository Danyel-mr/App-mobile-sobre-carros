import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_car/usuario.dart';

enum EmExibicao { telaCarros, telaDetalhes }

class GerenciadorEstado extends ChangeNotifier {
  EmExibicao _exibicao = EmExibicao.telaCarros;
  EmExibicao get exibicao => _exibicao;

  int _idCarro = -1;
  int get idCarro => _idCarro;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  // Texto da barra de pesquisa (mantido ao voltar da tela de detalhes).
  String filtro = "";

  // Comentários (com nota de 1 a 10) carregados do JSON e alterados na sessão.
  List<dynamic> _comentarios = [];
  Future<void>? _carregamentoComentarios;
  int _proximoIdComentario = 1;

  void exibirCarros() {
    _exibicao = EmExibicao.telaCarros;

    notifyListeners();
  }

  void exibirDetalhes(int idCarro) {
    _exibicao = EmExibicao.telaDetalhes;
    _idCarro = idCarro;

    notifyListeners();
  }

  void login(Usuario? usuario) {
    _usuario = usuario;

    notifyListeners();
  }

  void logout() {
    _usuario = null;

    notifyListeners();
  }

  Future<void> carregarComentarios() {
    _carregamentoComentarios ??= _lerComentarios();
    return _carregamentoComentarios!;
  }

  Future<void> _lerComentarios() async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/comentarios.json",
    );
    final dynamic dicionario = json.decode(conteudo);

    _comentarios = List<dynamic>.from(dicionario["comentarios"]);

    for (final c in _comentarios) {
      final int id = c["_id"] as int;
      if (id >= _proximoIdComentario) {
        _proximoIdComentario = id + 1;
      }
    }
  }

  List<dynamic> comentariosDoCarro(int idCarro) {
    return _comentarios.where((c) => c["carId"] == idCarro).toList();
  }

  int totalAvaliacoes(int idCarro) {
    return comentariosDoCarro(idCarro).length;
  }

  // Média das notas (1 a 10) ou null se o carro ainda não foi avaliado.
  double? notaMedia(int idCarro) {
    final comentarios = comentariosDoCarro(idCarro);
    if (comentarios.isEmpty) {
      return null;
    }

    int soma = 0;
    for (final c in comentarios) {
      soma += c["rating"] as int;
    }

    return soma / comentarios.length;
  }

  // Somente usuário logado pode comentar e dar nota.
  bool adicionarComentario(int idCarro, String conteudo, int nota) {
    if (_usuario == null || nota < 1 || nota > 10) {
      return false;
    }

    _comentarios.insert(0, {
      "_id": _proximoIdComentario++,
      "carId": idCarro,
      "user": {
        "userId": 9,
        "email": _usuario!.email,
        "name": _usuario!.nome,
      },
      "datetime": DateTime.now().toString(),
      "rating": nota,
      "content": conteudo,
    });

    notifyListeners();

    return true;
  }

  void removerComentario(int idComentario) {
    _comentarios.removeWhere((c) => c["_id"] == idComentario);

    notifyListeners();
  }
}

late GerenciadorEstado estadoApp;
