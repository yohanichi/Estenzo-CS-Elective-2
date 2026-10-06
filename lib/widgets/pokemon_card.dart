import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.tint,
    required this.onTap,
  });

  final Pokemon pokemon;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = pokemon.name[0].toUpperCase() + pokemon.name.substring(1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5EAE7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: tint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Image.network(
                              pokemon.imageUrl,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.catching_pokemon,
                                    size: 56,
                                    color: Color(0xFF9BA6A0),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 19,
                      right: 20,
                      child: Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          color: Color(0xFF69756F),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF202B27),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
