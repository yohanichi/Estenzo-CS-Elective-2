import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

class FavoritesPanel extends StatelessWidget {
  const FavoritesPanel({
    super.key,
    required this.state,
    required this.onToggle,
    required this.onRemove,
  });

  final PokemonState state;
  final VoidCallback onToggle;
  final ValueChanged<Pokemon> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: const Icon(Icons.favorite, color: Color(0xFFE84B55)),
          title: Text('Favorites (${state.favoriteIds.length})'),
          trailing: Icon(
            state.favoritesExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
          ),
          onTap: onToggle,
        ),
        if (state.favoritesExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: state.favoritePokemon.isEmpty
                ? const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No Pokémon have been favorited yet.',
                      style: TextStyle(color: Color(0xFF69756F)),
                    ),
                  )
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: state.favoritePokemon
                            .map(
                              (pokemon) => InputChip(
                                avatar: const Icon(
                                  Icons.favorite,
                                  size: 16,
                                  color: Color(0xFFE84B55),
                                ),
                                label: Text(
                                  state.nicknames[pokemon.id] ??
                                      _titleCase(pokemon.name),
                                ),
                                onDeleted: () => onRemove(pokemon),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ),
          ),
      ],
    );
  }

  String _titleCase(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}
