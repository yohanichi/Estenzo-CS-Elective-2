import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key, this.service});

  final PokemonService? service;

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  static const _tints = [
    Color(0xFFE7F3E9),
    Color(0xFFFFEFDF),
    Color(0xFFE7EFF8),
    Color(0xFFF9E7E5),
    Color(0xFFF1EAF6),
  ];

  late final PokemonService _service = widget.service ?? PokemonService();
  // FutureBuilder below displays this request's loading, result, and error states.
  late Future<List<Pokemon>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _service.fetchPokemon(limit: 30);
  }

  void _retry() {
    setState(() => _pokemonFuture = _service.fetchPokemon(limit: 30));
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: FutureBuilder<List<Pokemon>>(
                future: _pokemonFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _StatusView(
                      icon: null,
                      message: 'Loading Pokémon...',
                      loading: true,
                    );
                  }

                  if (snapshot.hasError) {
                    return _StatusView(
                      icon: Icons.wifi_off_outlined,
                      message: 'Could not load Pokémon.',
                      actionLabel: 'Try again',
                      onAction: _retry,
                    );
                  }

                  final pokemon = snapshot.data ?? const <Pokemon>[];
                  if (pokemon.isEmpty) {
                    return const _StatusView(
                      icon: Icons.search_off,
                      message: 'No Pokémon found.',
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = switch (constraints.maxWidth) {
                        >= 900 => 4,
                        >= 600 => 3,
                        _ => 2,
                      };

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.88,
                        ),
                        itemCount: pokemon.length,
                        itemBuilder: (context, index) => PokemonCard(
                          pokemon: pokemon[index],
                          tint: _tints[index % _tints.length],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
            FilledButton.tonal(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}