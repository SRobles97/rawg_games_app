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
  List<Videogame> _allVideogames = [];
  List<Videogame> _topRatedGames = [];
  List<Videogame> _topMetacriticGames = [];
  List<Videogame> _recentGames = [];

  List<Videogame> get topRatedGames => _topRatedGames;

  List<Videogame> get topMetacriticGames => _topMetacriticGames;

  List<Videogame> get recentGames => _recentGames;

  bool get isFetching => _isFetching;

  List<Videogame> get allVideogames => _allVideogames;

  Future<void> loadVideogames() async {
    if (_isFetching) return;

    _isFetching = true;
    try {
      final newVideogames = await _initVideogames(_currentPage);
      _allVideogames = [..._allVideogames, ...newVideogames];
      _updateSpecialLists();
      _currentPage++;
    } catch (error) {
      if (kDebugMode) {
        print("An error occurred while loading videogames: $error");
      }
    } finally {
      _isFetching = false;
    }
    state = _allVideogames;
  }

  void _updateSpecialLists() {
    // Actualizar los 5 juegos mejor valorados por rating
    _topRatedGames = [..._allVideogames]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    _topRatedGames = _topRatedGames.take(5).toList();

    // Actualizar los 5 juegos mejor valorados por metacritic
    var metacriticGames = _allVideogames
        .where((game) => game.metacritic != null)
        .toList()
      ..sort((a, b) => b.metacritic!.compareTo(a.metacritic!));
    _topMetacriticGames = metacriticGames.take(5).toList();

    // Actualizar los juegos más recientes por fecha de lanzamiento
    _recentGames = [..._allVideogames]
      ..sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    _recentGames = _recentGames.take(5).toList();
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
