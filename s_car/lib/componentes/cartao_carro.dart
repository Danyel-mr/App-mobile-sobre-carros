import 'package:flutter/material.dart';
import 'package:s_car/componentes/avatar_marca.dart';
import 'package:s_car/componentes/imagem_carro.dart';
import 'package:s_car/componentes/selo_nota.dart';
import 'package:s_car/gerenciador_estado.dart';

class CartaoCarro extends StatelessWidget {
  final dynamic carro;

  const CartaoCarro({super.key, required this.carro});

  @override
  Widget build(BuildContext context) {
    final int id = carro["_id"];
    final dynamic marca = carro["brand"];
    final dynamic dados = carro["car"];

    return GestureDetector(
      onTap: () {
        estadoApp.exibirDetalhes(id);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ImagemCarro(arquivo: dados["blobs"][0]["file"]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  AvatarMarca(marca: marca, raio: 12),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      marca["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Text(
                dados["name"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Wrap(
                spacing: 10,
                runSpacing: 2,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 13),
                      const SizedBox(width: 3),
                      Text("${dados["year"]}", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.speed, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        "${dados["topSpeed"]} km/h",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: SeloNota(
                nota: estadoApp.notaMedia(id),
                total: estadoApp.totalAvaliacoes(id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
