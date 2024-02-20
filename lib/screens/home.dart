import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:games_app/widgets/videogames_list.dart';

import 'package:http/http.dart' as http;

import '../models/videogame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Videogame>> _videogames;

  @override
  void initState() {
    super.initState();
    _videogames = _fetchVideogames();
  }

  Future<List<Videogame>> _fetchVideogames() async {
    const baseUrl = 'https://api.rawg.io/api/games';
    final apiKey = dotenv.env['API_KEY'];

    try {
      final response = await http.get(Uri.parse('$baseUrl?key=$apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['results'] as List<dynamic>;
        final videogames = data
            .map((videogameJson) => Videogame.fromJson(videogameJson))
            .toList();
        return videogames;
      } else {
        // Considera usar un error más específico o manejar diferentes códigos de estado
        throw Exception(
            'Failed to load videogames with status code: ${response.statusCode}');
      }
    } on Exception catch (e) {
      // Considera manejar o registrar la excepción específica
      throw Exception('Failed to load videogames: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videogames'),
      ),
      body: FutureBuilder<List<Videogame>>(
        future: _videogames,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return VideogameList(videogames: snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
