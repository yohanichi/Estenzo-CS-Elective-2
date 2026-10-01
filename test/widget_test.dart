// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/screens/pokedex_screen.dart';
import 'package:pokedex/services/pokemon_service.dart';

void main() {
  testWidgets('shows the first Pokémon in the list', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PokedexScreen(
          service: FakePokemonService(
            Future.value([samplePokemon]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('shows loading, error, and empty states', (tester) async {
    final completer = Completer<List<Pokemon>>();
    await tester.pumpWidget(
      MaterialApp(
        home: PokedexScreen(
          service: FakePokemonService(completer.future),
        ),
      ),
    );
    expect(find.text('Loading Pokémon...'), findsOneWidget);

    completer.completeError(Exception('offline'));
    await tester.pumpAndSettle();
    expect(find.text('Could not load Pokémon.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('shows an empty state when the API returns no Pokémon', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PokedexScreen(
          service: FakePokemonService(Future.value(const <Pokemon>[])),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No Pokémon found.'), findsOneWidget);
  });
}

const samplePokemon = Pokemon(
  id: 1,
  name: 'bulbasaur',
  imageUrl: 'https://example.com/bulbasaur.png',
);

class FakePokemonService extends PokemonService {
  FakePokemonService(this.result);

  final Future<List<Pokemon>> result;

  @override
  Future<List<Pokemon>> fetchPokemon({int limit = 30}) => result;
}
