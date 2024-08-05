import 'dart:convert';
import 'package:http/http.dart' as http;

class AnimeService {
  static const String _baseUrl = 'https://api.jikan.moe/v4';

  static Future<List<dynamic>> fetchTopAnime() async {
    final response = await http.get(Uri.parse('$_baseUrl/top/anime'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load top anime');
    }
  }

  static Future<dynamic> searchAnime(String keyWord) async {
    final response = await http.get(Uri.parse('$_baseUrl/anime?q=$keyWord'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load the anime');
    }
  }
}
