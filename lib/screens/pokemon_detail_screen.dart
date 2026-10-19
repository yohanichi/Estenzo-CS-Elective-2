import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/nickname_editor_dialog.dart';

class PokemonDetailScreen extends ConsumerWidget {
  const PokemonDetailScreen({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonControllerProvider);
    final controller = ref.read(pokemonControllerProvider.notifier);
    final nickname = state.nicknames[pokemon.id];

    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon details')),
      body: ListView(
        children: [
          FavoritesPanel(
            state: state,
            onToggle: controller.toggleFavoritesPanel,
            onRemove: controller.toggleFavorite,
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.catching_pokemon,
                      size: 96,
                      color: Color(0xFF9BA6A0),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(
                    color: Color(0xFFE84B55),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _titleCase(pokemon.name),
                  style: const TextStyle(
                    color: Color(0xFF202B27),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (nickname != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Nickname: $nickname',
                    style: const TextStyle(
                      color: Color(0xFF69756F),
                      fontSize: 16,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  pokemon.types.map(_titleCase).join(' · '),
                  style: const TextStyle(color: Color(0xFF69756F)),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _editNickname(context, ref, nickname),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(
                        nickname == null ? 'Add nickname' : 'Edit nickname',
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => controller.toggleFavorite(pokemon),
                      icon: Icon(
                        state.favoriteIds.contains(pokemon.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: const Color(0xFFE84B55),
                      ),
                      label: Text(
                        state.favoriteIds.contains(pokemon.id)
                            ? 'Unfavorite'
                            : 'Favorite',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editNickname(
    BuildContext context,
    WidgetRef ref,
    String? currentNickname,
  ) async {
    final nickname = await showDialog<String>(
      context: context,
      builder: (_) => NicknameEditorDialog(
        pokemonName: pokemon.name,
        initialNickname: currentNickname,
      ),
    );
    if (nickname != null) {
      ref
          .read(pokemonControllerProvider.notifier)
          .saveNickname(pokemon, nickname);
    }
  }

  String _titleCase(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}
