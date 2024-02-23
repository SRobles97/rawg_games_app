import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:games_app/providers/videogames_provider.dart';
import 'package:games_app/screens/index.dart';
import 'package:games_app/screens/splash.dart';
import 'package:games_app/screens/videogames.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: GamesApp()));
}

class GamesApp extends ConsumerStatefulWidget {
  const GamesApp({super.key});

  @override
  ConsumerState<GamesApp> createState() => _GamesAppState();
}

class _GamesAppState extends ConsumerState<GamesApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(videogamesProvider.notifier).loadVideogames());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Games App',
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends ConsumerWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videogames = ref.watch(videogamesProvider);

    return videogames.isNotEmpty ? const IndexScreen() : const SplashScreen();
  }
}
