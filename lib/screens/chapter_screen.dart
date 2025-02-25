import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/bible_books.dart';
import '../utils/bible_chapters.dart'; // Import du nombre de chapitres

class ChapterScreen extends StatefulWidget {
  final String book;
  final int chapter;
  final String livre;

  const ChapterScreen({super.key, required this.book, required this.livre , required this.chapter});

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  String chapterText = "Chargement...";
  bool isLoading = true; // Nouvelle variable pour suivre l'état du chargement

  @override
  void initState() {
    super.initState();
    fetchChapter();
  }

  Future<void> fetchChapter() async {
    setState(() {
      isLoading = true; // Début du chargement
    });

    String? latinBook = bibleBooksLatin[widget.book];

    if (latinBook == null) {
      setState(() {
        chapterText = "Livre non trouvé dans la Vulgate";
        isLoading = false; // Fin du chargement
      });
      return;
    }

    final url = "https://bible-api.com/${latinBook}+${widget.chapter}?translation=clementine";
    print("🔍 Fetching URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final verses = data["verses"] as List<dynamic>;
        final formattedText = verses.map((verse) => "${verse["verse"]}. ${verse["text"]}").join("\n\n");
        setState(() {
          chapterText = formattedText;
          isLoading = false; // Fin du chargement
        });
      } else {
        setState(() {
          chapterText = "Erreur de chargement (${response.statusCode})";
          isLoading = false; // Fin du chargement
        });
      }
    } catch (e) {
      setState(() {
        chapterText = "Erreur: $e";
        isLoading = false; // Fin du chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalChapters = bibleChapters[widget.book] ?? 1;
    print("📖 Book: ${widget.book}");
    print("📖 Livre: ${widget.livre}");
    print("📊 Nombre total de chapitres: $totalChapters");
    print("🔢 Chapitre actuel: ${widget.chapter}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.book} Chapitre ${widget.chapter}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey[800],
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey[50]!, Colors.blueGrey[100]!],
          ),
        ),
        child: Column(
          children: [
            // En-tête avec icône et nom du livre
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.book, // Icône représentant le livre
                    size: 60,
                    color: Colors.blueGrey[800],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.book,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Bloc de texte du chapitre ou indicateur de chargement
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            chapterText,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
            ),

            // Boutons de navigation et indicateur de progression
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: const Text(
                          "Précédent",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: widget.chapter > 1
                            ? () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterScreen(
                                      book: widget.book,
                                      livre: widget.livre,
                                      chapter: widget.chapter - 1,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[800],
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        label: const Text(
                          "Suivant",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: (totalChapters != null && widget.chapter < totalChapters)
                            ? () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterScreen(
                                      book: widget.book,
                                      livre: widget.livre,
                                      chapter: widget.chapter + 1,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[800],
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: widget.chapter / totalChapters,
                    backgroundColor: Colors.blueGrey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey[800]!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 