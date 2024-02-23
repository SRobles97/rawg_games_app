import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:games_app/screens/home.dart';
import 'package:games_app/screens/videogames.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _selectedIndex = 0;

  final _pages = [
    const HomeScreen(),
    const VideogamesScreen(),
    const Text('Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.title),
          actions: [
            IconButton(
              onPressed: null, // TODO: Implement search
              icon: Icon(
                  Platform.isAndroid ? Icons.search : CupertinoIcons.search),
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedFontSize: 12,
          unselectedFontSize: 10,
          unselectedItemColor: Theme.of(context).colorScheme.tertiary,
          selectedItemColor: Theme.of(context).appBarTheme.backgroundColor,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          currentIndex: _selectedIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.videogame_asset),
              label: AppLocalizations.of(context)!.games,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              label: AppLocalizations.of(context)!.favorites,
            ),
          ],
        ));
  }
}
