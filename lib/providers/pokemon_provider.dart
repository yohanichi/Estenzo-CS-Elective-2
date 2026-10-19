import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

enum PokemonStatus { loading, success, error }

final pokemonServiceProvider = Provider<PokemonService>(
  (ref) => PokemonService(),
);

final pokemonControllerProvider =
    StateNotifierProvider<PokemonController, PokemonState>((ref) {
      final controller = PokemonController(ref.watch(pokemonServiceProvider));
      controller.fetchPokemon();
      return controller;
    });

class PokemonState {
  const PokemonState({
    this.status = PokemonStatus.loading,
    this.pokemon = const [],
    this.errorMessage,
    this.nicknames = const {},
    this.favoriteIds = const {},
    this.selectedType,
    this.favoritesExpanded = false,
  });

  final PokemonStatus status;
  final List<Pokemon> pokemon;
  final String? errorMessage;
  final Map<int, String> nicknames;
  final Set<int> favoriteIds;
  final String? selectedType;
  final bool favoritesExpanded;

  List<Pokemon> get visiblePokemon => selectedType == null
      ? pokemon
      : pokemon
            .where((pokemon) => pokemon.types.contains(selectedType))
            .toList(growable: false);

  List<Pokemon> get favoritePokemon =>
      pokemon.where((pokemon) => favoriteIds.contains(pokemon.id)).toList();

  List<String> get availableTypes =>
      pokemon.expand((pokemon) => pokemon.types).toSet().toList()..sort();

  PokemonState copyWith({
    PokemonStatus? status,
    List<Pokemon>? pokemon,
    String? errorMessage,
    bool clearError = false,
    Map<int, String>? nicknames,
    Set<int>? favoriteIds,
    String? selectedType,
    bool clearTypeFilter = false,
    bool? favoritesExpanded,
  }) {
    return PokemonState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      nicknames: nicknames ?? this.nicknames,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedType: clearTypeFilter ? null : selectedType ?? this.selectedType,
      favoritesExpanded: favoritesExpanded ?? this.favoritesExpanded,
    );
  }
}

class PokemonController extends StateNotifier<PokemonState> {
  PokemonController(this._service) : super(const PokemonState());

  final PokemonService _service;

  Future<void> fetchPokemon() async {
    state = state.copyWith(status: PokemonStatus.loading, clearError: true);
    try {
      final pokemon = await _service.fetchPokemon(limit: 30);
      state = state.copyWith(
        status: PokemonStatus.success,
        pokemon: pokemon,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: PokemonStatus.error,
        errorMessage:
            'Could not load Pokémon. Check your connection and try again. ($error)',
      );
    }
  }

  void toggleFavorite(Pokemon pokemon) {
    final favoriteIds = {...state.favoriteIds};
    if (!favoriteIds.add(pokemon.id)) {
      favoriteIds.remove(pokemon.id);
    }
    state = state.copyWith(favoriteIds: favoriteIds);
  }

  void saveNickname(Pokemon pokemon, String nickname) {
    final nicknames = {...state.nicknames};
    final trimmedNickname = nickname.trim();
    if (trimmedNickname.isEmpty) {
      nicknames.remove(pokemon.id);
    } else {
      nicknames[pokemon.id] = trimmedNickname;
    }
    state = state.copyWith(nicknames: nicknames);
  }

  void setTypeFilter(String? type) {
    state = type == null
        ? state.copyWith(clearTypeFilter: true)
        : state.copyWith(selectedType: type);
  }

  void toggleFavoritesPanel() {
    state = state.copyWith(favoritesExpanded: !state.favoritesExpanded);
  }
}
