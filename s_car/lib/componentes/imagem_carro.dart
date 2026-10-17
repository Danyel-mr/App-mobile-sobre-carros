import 'package:flutter/material.dart';

// Imagem do carro (recursos/imagens/carros/<arquivo>).
// Se o arquivo não existir, mostra um ícone no lugar.
class ImagemCarro extends StatelessWidget {
  final String arquivo;
  final BoxFit fit;

  const ImagemCarro({super.key, required this.arquivo, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "recursos/imagens/carros/$arquivo",
      fit: fit,
      width: double.infinity,
      errorBuilder: (context, erro, pilha) {
        return Container(
          color: Colors.black12,
          alignment: Alignment.center,
          child: const Icon(
            Icons.directions_car,
            size: 48,
            color: Colors.black38,
          ),
        );
      },
    );
  }
}
