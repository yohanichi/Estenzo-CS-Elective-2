import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // One HTTP request returns a single batch, so expose it as a Future, not a Stream.
  Future<List<Pokemon>> fetchPokemon({int limit = 30}) async {
    final response = await _client.get(
      Uri.https('pokeapi.co', '/api/v2/pokemon', {'limit': '$limit'}),
    );

    if (response.statusCode != 200) {
      throw http.ClientException(
        'PokéAPI returned status ${response.statusCode}',
        response.request?.url,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final results = payload['results'] as List<dynamic>;
    return Future.wait(
      results.map((result) async {
        final entry = result as Map<String, dynamic>;
        final detailsResponse = await _client.get(
          Uri.parse(entry['url'] as String),
        );
        if (detailsResponse.statusCode != 200) {
          throw http.ClientException(
            'PokéAPI returned status ${detailsResponse.statusCode}',
            detailsResponse.request?.url,
          );
        }
        return Pokemon.fromApiJson(
          jsonDecode(detailsResponse.body) as Map<String, dynamic>,
        );
      }),
    );
  }
}
