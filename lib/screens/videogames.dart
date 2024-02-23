import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_app/widgets/videogames_grid.dart';
import 'package:games_app/widgets/videogames_list.dart';
import '../providers/videogames_provider.dart';

class VideogamesScreen extends ConsumerStatefulWidget {
  const VideogamesScreen({super.key});

  @override
  ConsumerState<VideogamesScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<VideogamesScreen> {
  final _scrollController = ScrollController();
  bool _isGrid = true;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isAscending = !_isAscending;
                        ref
                            .read(videogamesProvider.notifier)
                            .filterByRating(_isAscending);
                      });
                    },
                    icon: Icon(Platform.isAndroid
                        ? _isAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward
                        : _isAscending
                            ? CupertinoIcons.arrow_up
                            : CupertinoIcons.arrow_down)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isGrid = !_isGrid;
                    });
                  },
                  icon: Icon(
                    _isGrid
                        ? Platform.isIOS
                            ? CupertinoIcons.square_list
                            : Icons.list
                        : Platform.isIOS
                            ? CupertinoIcons.square_grid_2x2
                            : Icons.grid_view,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          SliverFillRemaining(
              child: _isGrid
                  ? VideogameGrid(
                      videogames: videogames,
                      scrollController: _scrollController,
                    )
                  : VideogameList(
                      videogames: videogames,
                      scrollController: _scrollController)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
