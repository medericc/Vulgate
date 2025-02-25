import 'package:flutter/material.dart';
import '../data/verse_model.dart';

class VerseTile extends StatelessWidget {
  final Verse verse;
  final VoidCallback onTap;

  const VerseTile({super.key, required this.verse, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(verse.text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(verse.translation, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
      onTap: onTap,
    );
  }
}