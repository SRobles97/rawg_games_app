import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_app/widgets/metascore.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/videogames_provider.dart';
import '../screens/videogame_details.dart';

class TopMetacriticWidget extends ConsumerWidget {
  const TopMetacriticWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topMetacriticGames =
        ref.read(videogamesProvider.notifier).topMetacriticGames;

    return topMetacriticGames.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Top 5 best Metacritic scores',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topMetacriticGames.length,
                  itemBuilder: (context, index) {
                    final game = topMetacriticGames[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              VideogameDetails(videogame: game),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: game.imageUrl,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: MetaScoreWidget(
                                  metascore: game.metacritic,
                                )),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.black54,
                                child: Text(
                                  game.title,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
