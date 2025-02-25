class TextParser {
  static List<String> extractWords(String verse) {
    return verse.split(RegExp(r'\s+')); // Sépare les mots par espaces
  }
}