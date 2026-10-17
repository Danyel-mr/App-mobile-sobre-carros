import 'package:flutter/material.dart';

// Escolha da nota de 1 a 10 (usuário logado).
class SeletorNota extends StatelessWidget {
  final int? notaSelecionada;
  final void Function(int nota) onSelecionou;

  const SeletorNota({
    super.key,
    required this.notaSelecionada,
    required this.onSelecionou,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 0,
      children: List.generate(10, (indice) {
        final int nota = indice + 1;

        return ChoiceChip(
          label: Text("$nota"),
          selected: notaSelecionada == nota,
          showCheckmark: false,
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: notaSelecionada == nota
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          onSelected: (_) => onSelecionou(nota),
        );
      }),
    );
  }
}
