import 'package:http/http.dart' as http;
import 'dart:convert';

class AniListService {
  final String apiUrl = 'https://graphql.anilist.co';

  Future<List<dynamic>> fetchManga() async {
    const query = '''
      query {
        Page {
          media(type: MANGA) {
            id
            title {
              romaji
              english
            }
            coverImage {
              medium
            }
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'query': query}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data']['Page']['media'];
    } else {
      throw Exception('Failed to load manga');
    }
  }
}
