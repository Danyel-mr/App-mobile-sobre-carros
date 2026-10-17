import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s_car/componentes/selo_nota.dart';

class CartaoComentario extends StatelessWidget {
  final dynamic comentario;
  final bool somenteLeitura;

  const CartaoComentario({
    super.key,
    required this.comentario,
    required this.somenteLeitura,
  });

  @override
  Widget build(BuildContext context) {
    String dataFormatada = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.parse(comentario["datetime"]));

    return Card(
      color: somenteLeitura ? Colors.white54 : Colors.green[100],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    comentario["user"]["name"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SeloNota(
                  nota: (comentario["rating"] as int).toDouble(),
                  casasDecimais: 0,
                ),
                const Text("/10", style: TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 4),
            Text(comentario["content"], style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text(
              dataFormatada,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
