import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = context.watch<PokemonProvider>().selectedPokemon;

    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon details')),
      body: pokemon == null
          ? const Center(child: Text('No Pokémon selected.'))
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
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
                      pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                      style: const TextStyle(
                        color: Color(0xFF202B27),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
