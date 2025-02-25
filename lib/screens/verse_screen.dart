import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/bible_books.dart'; // Import du fichier contenant les noms latins

class VerseScreen extends StatefulWidget {
  final String reference; // Exemple: "John 3:16"

  const VerseScreen({super.key, required this.reference});

  @override
  _VerseScreenState createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  String verseText = "Chargement...";

  @override
  void initState() {
    super.initState();
    fetchVerse();
  }

  Future<void> fetchVerse() async {
    // Séparation du livre et du chapitre:verset
    List<String> parts = widget.reference.split(" ");
    if (parts.length < 2) {
      setState(() {
        verseText = "Référence invalide";
      });
      return;
    }

    String book = parts.sublist(0, parts.length - 1).join(" ");
    String chapterVerse = parts.last;

    // Conversion du nom du livre en latin
    String? latinBook = bibleBooksLatin[book];

    if (latinBook == null) {
      setState(() {
        verseText = "Livre non trouvé dans la Vulgate";
      });
      return;
    }

    final url = "https://bible-api.com/${latinBook}+${chapterVerse}?translation=clementine";
    print("🔍 Fetching URL: $url"); // Debugging

    try {
      final response = await http.get(Uri.parse(url));
      print("📩 Response Status: ${response.statusCode}");
      print("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          verseText = data["text"] ?? "Verset introuvable";
        });
      } else {
        setState(() {
          verseText = "Erreur de chargement (${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        verseText = "Erreur: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.reference)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            verseText,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
