import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:games_app/screens/image.dart';
import 'package:games_app/widgets/metascore.dart';

import 'package:games_app/widgets/stars_row.dart';

import '../models/videogame.dart';

class VideogameDetails extends StatelessWidget {
  final Videogame videogame;

  const VideogameDetails({super.key, required this.videogame});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImageScreen(
                    imageUrl: videogame.imageUrl,
                    videogameId: videogame.id,
                  ),
                ));
              },
              child: Hero(
                  tag: videogame.id,
                  child: Image.network(
                    videogame.imageUrl,
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              iconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.secondary),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(
                    Platform.isIOS
                        ? CupertinoIcons.heart
                        : Icons.favorite_border,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 160,
            left: 0,
            right: 0,
            bottom: 5,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.75),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      videogame.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                                  StarsRowWidget(rating: videogame.rating),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            surfaceTintColor:
                                Theme.of(context).colorScheme.secondary,
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.start,
                                            "${AppLocalizations.of(context)!.release_date}:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Platform.isIOS
                                                    ? CupertinoIcons.calendar
                                                    : Icons.calendar_today,
                                                color: Theme.of(context)
                                                    .appBarTheme
                                                    .backgroundColor,
                                                size: 36,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(videogame.releaseDate),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.start,
                                            "${AppLocalizations.of(context)!.metacritic}:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          MetaScoreWidget(
                                              metascore: videogame.metacritic),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
