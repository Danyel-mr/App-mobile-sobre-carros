import 'package:flutter/material.dart';

// Selo com estrela e nota (1 a 10). Cor: verde (>= 8), âmbar (>= 5), vermelho.
class SeloNota extends StatelessWidget {
  final double? nota;
  final int? total;
  final int casasDecimais;
  final double tamanhoFonte;

  const SeloNota({
    super.key,
    required this.nota,
    this.total,
    this.casasDecimais = 1,
    this.tamanhoFonte = 12,
  });

  static String formatar(double nota, int casasDecimais) {
    return nota.toStringAsFixed(casasDecimais).replaceAll(".", ",");
  }

  Color _cor() {
    if (nota == null) {
      return Colors.grey;
    }
    if (nota! >= 8) {
      return Colors.green.shade700;
    }
    if (nota! >= 5) {
      return Colors.amber.shade800;
    }
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    if (nota == null) {
      return Text(
        "sem avaliações",
        style: TextStyle(fontSize: tamanhoFonte, color: Colors.black54),
      );
    }

    final Color cor = _cor();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: cor, size: tamanhoFonte + 6),
        const SizedBox(width: 2),
        Text(
          formatar(nota!, casasDecimais),
          style: TextStyle(
            fontSize: tamanhoFonte,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        if (total != null)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "($total)",
              style: TextStyle(fontSize: tamanhoFonte - 1, color: Colors.black54),
            ),
          ),
      ],
    );
  }
}
