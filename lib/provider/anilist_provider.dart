import 'package:http/http.dart' as http;
import 'dart:convert';

class JikanService {
  final String apiUrl = 'https://api.jikan.moe/v4';

  Future<List<dynamic>> fetchManga() async {
    final response = await http.get(Uri.parse('$apiUrl/manga'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load manga');
    }
  }
}
