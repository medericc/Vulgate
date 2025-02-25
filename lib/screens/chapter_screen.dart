import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/bible_books.dart';
import '../utils/bible_chapters.dart'; // Import du nombre de chapitres
import 'package:flutter/gestures.dart';

class ChapterScreen extends StatefulWidget {
  final String book;
  final int chapter;
  final String livre;

  const ChapterScreen({super.key, required this.book, required this.livre, required this.chapter});

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  String chapterText = "Chargement...";
  bool isLoading = true;
  Map<int, String> translatedWords = {}; // Stocke les traductions des mots
  Map<int, bool> isTranslated = {}; // Indique si un mot est traduit ou non

  @override
  void initState() {
    super.initState();
    fetchChapter();
  }

  Future<void> fetchChapter() async {
    setState(() {
      isLoading = true;
    });

    String? latinBook = bibleBooksLatin[widget.book];

    if (latinBook == null) {
      setState(() {
        chapterText = "Livre non trouvé dans la Vulgate";
        isLoading = false;
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
          isLoading = false;
        });
      } else {
        print("Erreur de chargement: ${response.statusCode}, Body: ${response.body}");
        setState(() {
          chapterText = "Erreur de chargement (${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        chapterText = "Erreur: $e";
        isLoading = false;
      });
    }
  }

  Future<String> translateMyMemory(String text, String sourceLang, String targetLang) async {
    final url = Uri.parse("https://api.mymemory.translated.net/get?q=$text&langpair=$sourceLang|$targetLang");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["responseData"]["translatedText"]; // Retourne la traduction
      } else {
        throw Exception("Erreur API: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la traduction: $e");
    }
  }

  Future<String> translateWord(String word, String targetLanguage) async {
    // Utilise MyMemory pour traduire le mot
    return translateMyMemory(word, "la", targetLanguage); // "la" pour le latin
  }

  Widget buildTextWithClickableWords(String text) {
    List<TextSpan> textSpans = [];
    List<String> words = text.split(" ");

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      textSpans.add(
        TextSpan(
          text: "${translatedWords[i] ?? word} ",
          style: TextStyle(
            color: isTranslated[i] == true ? Colors.blue : Colors.black,
            fontWeight: isTranslated[i] == true ? FontWeight.bold : FontWeight.normal,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              setState(() {
                if (isTranslated[i] == true) {
                  // Revenir au mot original en latin
                  translatedWords.remove(i);
                  isTranslated[i] = false;
                } else {
                  // Traduire le mot en français
                  translateWord(word, "fr").then((translated) {
                    setState(() {
                      translatedWords[i] = translated;
                      isTranslated[i] = true;
                    });
                  }).catchError((error) {
                    print("Erreur lors de la traduction: $error");
                  });
                }
              });
            },
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
      textAlign: TextAlign.justify,
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalChapters = bibleChapters[widget.book] ?? 1;

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.book,
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
                          child: buildTextWithClickableWords(chapterText),
                        ),
                      ),
                    ),
            ),
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