class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
  });

  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  factory Pokemon.fromApiJson(Map<String, dynamic> json) {
    final id =
        json['id'] as int? ??
        _idFromUrl(
          json['url'] as String? ??
              (throw const FormatException(
                'Pokémon API response must include an id or URL.',
              )),
        );
    final types = ((json['types'] as List<dynamic>?) ?? const [])
        .map(
          (entry) =>
              (entry as Map<String, dynamic>)['type'] as Map<String, dynamic>,
        )
        .map((type) => type['name'] as String)
        .toList(growable: false);

    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      types: types,
    );
  }

  static int _idFromUrl(String url) {
    final segments = Uri.parse(
      url,
    ).pathSegments.where((segment) => segment.isNotEmpty);
    if (segments.isEmpty) {
      throw const FormatException('Pokémon API URL does not contain an id.');
    }
    final id = int.tryParse(segments.last);
    if (id == null) {
      throw const FormatException('Pokémon API URL contains an invalid id.');
    }
    return id;
  }
}
