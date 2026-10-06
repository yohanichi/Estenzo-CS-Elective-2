import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

enum PokemonStatus { loading, success, error }

class PokemonProvider extends ChangeNotifier {
  PokemonProvider({PokemonService? service})
    : _service = service ?? PokemonService() {
    fetchPokemon();
  }

  final PokemonService _service;

  List<Pokemon> _pokemon = const [];
  Pokemon? _selectedPokemon;
  PokemonStatus _status = PokemonStatus.loading;
  String? _errorMessage;

  List<Pokemon> get pokemon => _pokemon;
  Pokemon? get selectedPokemon => _selectedPokemon;
  PokemonStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPokemon() async {
    _status = PokemonStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemon = await _service.fetchPokemon(limit: 30);
      _status = PokemonStatus.success;
    } catch (error) {
      _errorMessage = error.toString();
      _status = PokemonStatus.error;
    }

    notifyListeners();
  }

  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }
}
