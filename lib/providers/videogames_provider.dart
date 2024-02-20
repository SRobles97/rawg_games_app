import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/videogame.dart';

Future _initVideogames(int page) async {
  final response = await http.get(Uri.parse(
      'https://api.rawg.io/api/games?key=${dotenv.env['API_KEY']}&page=$page'));
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

  Future<void> loadVideogames() async {
    if (_isFetching) return;

    _isFetching = true;
    try {
      final newVideogames = await _initVideogames(_currentPage);
      state = [...state, ...newVideogames];
      _currentPage++;
    } catch (error) {
      if (kDebugMode) {
        print("An error occurred while loading videogames: $error");
      }
    } finally {
      _isFetching = false;
    }
  }
}

final videogamesProvider =
    StateNotifierProvider<VideogamesNotifier, List<Videogame>>((ref) {
  return VideogamesNotifier();
});
