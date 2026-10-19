// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/screens/pokedex_screen.dart';
import 'package:pokedex/services/pokemon_service.dart';

void main() {
  test('parses Pokémon details returned by PokéAPI', () {
    final pokemon = Pokemon.fromApiJson({
      'id': 1,
      'name': 'bulbasaur',
      'types': [
        {
          'slot': 1,
          'type': {
            'name': 'grass',
            'url': 'https://pokeapi.co/api/v2/type/12/',
          },
        },
        {
          'slot': 2,
          'type': {
            'name': 'poison',
            'url': 'https://pokeapi.co/api/v2/type/4/',
          },
        },
      ],
    });

    expect(pokemon.id, 1);
    expect(pokemon.name, 'bulbasaur');
    expect(pokemon.types, ['grass', 'poison']);
  });

  testWidgets('shows the first Pokémon in the list', (tester) async {
    await _pumpPokedex(
      tester,
      FakePokemonService(Future.value([samplePokemon, firePokemon])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('shows loading, error, and empty states', (tester) async {
    final completer = Completer<List<Pokemon>>();
    await _pumpPokedex(tester, FakePokemonService(completer.future));
    expect(find.text('Loading Pokémon...'), findsOneWidget);

    completer.completeError(Exception('offline'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not load Pokémon.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('shows an empty state when the API returns no Pokémon', (
    tester,
  ) async {
    await _pumpPokedex(
      tester,
      FakePokemonService(Future.value(const <Pokemon>[])),
    );
    await tester.pumpAndSettle();
    expect(find.text('No Pokémon found.'), findsOneWidget);
  });

  testWidgets('favorites, nickname editing, and type filtering update the UI', (
    tester,
  ) async {
    await _pumpPokedex(
      tester,
      FakePokemonService(Future.value([samplePokemon, firePokemon])),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pump();
    expect(find.text('Favorites (1)'), findsOneWidget);

    await tester.tap(find.byTooltip('Add nickname').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Sprout');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('“Sprout”'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fire').last);
    await tester.pumpAndSettle();
    expect(find.text('Charmander'), findsOneWidget);
    expect(find.text('Bulbasaur'), findsNothing);
  });
}

Future<void> _pumpPokedex(WidgetTester tester, PokemonService service) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [pokemonServiceProvider.overrideWithValue(service)],
      child: const MaterialApp(home: PokedexScreen()),
    ),
  );
}

const samplePokemon = Pokemon(
  id: 1,
  name: 'bulbasaur',
  imageUrl: 'https://example.com/bulbasaur.png',
  types: ['grass'],
);

const firePokemon = Pokemon(
  id: 4,
  name: 'charmander',
  imageUrl: 'https://example.com/charmander.png',
  types: ['fire'],
);

class FakePokemonService extends PokemonService {
  FakePokemonService(this.result);

  final Future<List<Pokemon>> result;

  @override
  Future<List<Pokemon>> fetchPokemon({int limit = 30}) => result;
}
