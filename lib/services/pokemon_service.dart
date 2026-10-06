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
    return results
        .map((result) => Pokemon.fromApiJson(result as Map<String, dynamic>))
        .toList(growable: false);
  }
}