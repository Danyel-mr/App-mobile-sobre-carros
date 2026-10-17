import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ControlesUsuario extends StatelessWidget {
  final dynamic carro;

  const ControlesUsuario({super.key, required this.carro});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: CircleAvatar(
        backgroundColor: Colors.white70,
        child: IconButton(
          onPressed: () {
            final texto =
                '${carro["brand"]["name"]} ${carro["car"]["name"]} (${carro["car"]["year"]}) - ${carro["car"]["topSpeed"]} km/h, visto no S-Car.\n\n\nBaixe o S-Car na PlayStore!';
            SharePlus.instance.share(ShareParams(title: "S-Car", text: texto));
          },
          icon: const Icon(Icons.share),
          color: Colors.blue,
          iconSize: 22,
        ),
      ),
    );
  }
}
