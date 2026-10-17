import 'package:flutter/material.dart';
import 'package:s_car/componentes/selo_nota.dart';
import 'package:s_car/gerenciador_estado.dart';

class CartaoDetalhesCarro extends StatelessWidget {
  final dynamic carro;

  const CartaoDetalhesCarro({super.key, required this.carro});

  Widget _linhaInformacao(IconData icone, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int id = carro["_id"];
    final dynamic marca = carro["brand"];
    final dynamic dados = carro["car"];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marca["name"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        dados["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SeloNota(
                  nota: estadoApp.notaMedia(id),
                  total: estadoApp.totalAvaliacoes(id),
                  tamanhoFonte: 15,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(dados["description"], style: const TextStyle(fontSize: 13)),
            const Divider(height: 20),
            _linhaInformacao(
              Icons.calendar_today,
              "Ano de fabricação",
              "${dados["year"]}",
            ),
            _linhaInformacao(
              Icons.speed,
              "Velocidade máxima",
              "${dados["topSpeed"]} km/h",
            ),
            _linhaInformacao(Icons.bolt, "Performance", dados["performance"]),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Valores aproximados, baseados em dados divulgados na época do lançamento.",
                style: TextStyle(fontSize: 10, color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
