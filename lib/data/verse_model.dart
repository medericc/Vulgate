class Verse {
  final int id;
  final String text;
  final String translation;

  Verse({required this.id, required this.text, required this.translation});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      translation: json['translation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'translation': translation,
    };
  }
}