import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/nickname_editor_dialog.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  static const _tints = [
    Color(0xFFE7F3E9),
    Color(0xFFFFEFDF),
    Color(0xFFE7EFF8),
    Color(0xFFF9E7E5),
    Color(0xFFF1EAF6),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonControllerProvider);
    final controller = ref.read(pokemonControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 20,
        title: Row(
          children: [
            const Icon(Icons.catching_pokemon, color: Color(0xFFE84B55)),
            const SizedBox(width: 9),
            const Text(
              'Pokédex',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Pokémon',
            onPressed: controller.fetchPokemon,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NATIONAL INDEX',
                    style: TextStyle(
                      color: Color(0xFFE84B55),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Discover Pokémon',
                    style: TextStyle(
                      color: Color(0xFF202B27),
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            FavoritesPanel(
              state: state,
              onToggle: controller.toggleFavoritesPanel,
              onRemove: controller.toggleFavorite,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: DropdownButtonFormField<String>(
                initialValue: state.selectedType ?? '',
                decoration: const InputDecoration(
                  labelText: 'Filter by type',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(value: '', child: Text('All types')),
                  ...state.availableTypes.map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(_titleCase(type)),
                    ),
                  ),
                ],
                onChanged: (type) =>
                    controller.setTypeFilter(type == '' ? null : type),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchPokemon,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (state.status == PokemonStatus.loading) {
                      return _statusList(
                        constraints.maxHeight,
                        const _StatusView(
                          icon: null,
                          message: 'Loading Pokémon...',
                          loading: true,
                        ),
                      );
                    }

                    if (state.status == PokemonStatus.error) {
                      return _statusList(
                        constraints.maxHeight,
                        _StatusView(
                          icon: Icons.wifi_off_outlined,
                          message:
                              state.errorMessage ?? 'Could not load Pokémon.',
                          actionLabel: 'Try again',
                          onAction: controller.fetchPokemon,
                        ),
                      );
                    }

                    if (state.visiblePokemon.isEmpty) {
                      return _statusList(
                        constraints.maxHeight,
                        _StatusView(
                          icon: Icons.search_off,
                          message: state.selectedType == null
                              ? 'No Pokémon found.'
                              : 'No Pokémon match this filter.',
                        ),
                      );
                    }

                    final columns = switch (constraints.maxWidth) {
                      >= 900 => 4,
                      >= 600 => 3,
                      _ => 2,
                    };

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.88,
                      ),
                      itemCount: state.visiblePokemon.length,
                      itemBuilder: (context, index) {
                        final pokemon = state.visiblePokemon[index];
                        return PokemonCard(
                          pokemon: pokemon,
                          tint: _tints[index % _tints.length],
                          nickname: state.nicknames[pokemon.id],
                          isFavorite: state.favoriteIds.contains(pokemon.id),
                          onFavorite: () => controller.toggleFavorite(pokemon),
                          onEditNickname: () =>
                              _editNickname(context, ref, pokemon),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    PokemonDetailScreen(pokemon: pokemon),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editNickname(
    BuildContext context,
    WidgetRef ref,
    Pokemon pokemon,
  ) async {
    final nickname = await showDialog<String>(
      context: context,
      builder: (_) => NicknameEditorDialog(
        pokemonName: pokemon.name,
        initialNickname: ref
            .read(pokemonControllerProvider)
            .nicknames[pokemon.id],
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

  Widget _statusList(double height, Widget status) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [SizedBox(height: height, child: status)],
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.icon,
    required this.message,
    this.loading = false,
    this.actionLabel,
    this.onAction,
  });

  final IconData? icon;
  final String message;
  final bool loading;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          else if (icon != null)
            Icon(icon, size: 38, color: const Color(0xFF87938D)),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF46534D),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
