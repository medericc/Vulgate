import 'package:http/http.dart' as http;
import 'dart:convert';

class BibleApiService {
  static const String baseUrl = 'https://bible-api.com/';

  static Future<Map<String, dynamic>> fetchVerse(String reference) async {
    final response = await http.get(Uri.parse('$baseUrl$reference?translation=clementine'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec du chargement du verset');
    }
  }
}
