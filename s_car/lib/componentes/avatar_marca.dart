import 'package:flutter/material.dart';

// Círculo com a inicial da marca, na cor da marca (campo "color" do JSON).
class AvatarMarca extends StatelessWidget {
  final dynamic marca;
  final double raio;

  const AvatarMarca({super.key, required this.marca, this.raio = 14});

  static Color converterCor(String? hex) {
    if (hex == null || !hex.startsWith("#") || hex.length != 7) {
      return Colors.grey;
    }

    final int? valor = int.tryParse(hex.substring(1), radix: 16);

    return valor == null ? Colors.grey : Color(0xFF000000 | valor);
  }

  @override
  Widget build(BuildContext context) {
    final String nome = marca["name"].toString();
    final Color cor = converterCor(marca["color"]?.toString());

    return CircleAvatar(
      radius: raio,
      backgroundColor: cor,
      child: Text(
        nome.isNotEmpty ? nome[0].toUpperCase() : "?",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: raio * 0.95,
        ),
      ),
    );
  }
}
