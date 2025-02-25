import 'package:flutter/material.dart';

class WordTranslation extends StatelessWidget {
  final String word;
  final String translation;

  const WordTranslation({super.key, required this.word, required this.translation});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: translation,
      child: Text(
        word,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue,
        ),
      ),
    );
  }
}
