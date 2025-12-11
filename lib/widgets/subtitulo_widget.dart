import 'package:flutter/material.dart';

class SubtituloWidget extends StatelessWidget {
  final String texto;
  const SubtituloWidget({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
