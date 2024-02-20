import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_app/widgets/videogames_grid.dart';
import '../providers/videogames_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _videogamesFuture;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _videogamesFuture = ref.read(videogamesProvider.notifier).loadVideogames();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(videogamesProvider.notifier).loadVideogames();
    }
  }

  @override
  Widget build(BuildContext context) {
    final videogames = ref.watch(videogamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Videogames'),
      ),
      body: FutureBuilder(
          future: _videogamesFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : VideogameGrid(
                    videogames: videogames,
                    scrollController: _scrollController);
          }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
