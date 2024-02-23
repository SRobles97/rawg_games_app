import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/videogame.dart';

Future _initVideogames(int page) async {
  final response = await http.get(Uri.parse(
      'https://api.rawg.io/api/games?key=${dotenv.env['API_KEY']}&page=$page&page_size=100'));
  final extractedData = json.decode(response.body) as Map<String, dynamic>;
  final List<Videogame> loadedVideogames = extractedData['results']
      .map<Videogame>((gameData) => Videogame.fromJson(gameData))
      .toList();
  return loadedVideogames;
}

class VideogamesNotifier extends StateNotifier<List<Videogame>> {
  VideogamesNotifier() : super([]);

  int _currentPage = 1;
  bool _isFetching = false;
  List<Videogame> _allVideogames =
      []; // Almacenará todos los videojuegos cargados

  bool get isFetching => _isFetching;

  List<Videogame> get allVideogames => _allVideogames;

  Future<void> loadVideogames() async {
    if (_isFetching) return;

    _isFetching = true;
    try {
      final newVideogames = await _initVideogames(_currentPage);
      _allVideogames = [..._allVideogames, ...newVideogames]; // Almacenar todos los videojuegos
      state = [...state, ...newVideogames]; // Solo añade nuevos videojuegos al estado existente
      _currentPage++;
    } catch (error) {
      if (kDebugMode) {
        print("An error occurred while loading videogames: $error");
      }
    } finally {
      _isFetching = false;
    }
  }


  void filterByRating(bool isAscending) {
    // Filtra y ordena la lista de todos los videojuegos cargados
    List<Videogame> sortedVideogames = List.from(_allVideogames);
    sortedVideogames.sort((a, b) => isAscending
        ? a.rating.compareTo(b.rating)
        : b.rating.compareTo(a.rating));
    state =
        sortedVideogames; // Actualizar la vista actual con los videojuegos filtrados y ordenados
  }

  Future<void> refreshVideogames() async {
    _currentPage = 1;
    _allVideogames = []; // Resetear la lista completa de videojuegos
    await loadVideogames();
  }
}

final videogamesProvider =
    StateNotifierProvider<VideogamesNotifier, List<Videogame>>((ref) {
  return VideogamesNotifier();
});
