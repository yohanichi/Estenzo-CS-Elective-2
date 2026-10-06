class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String imageUrl;

  factory Pokemon.fromApiJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = int.parse(
      Uri.parse(url).pathSegments.where((segment) => segment.isNotEmpty).last,
    );

    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }
}