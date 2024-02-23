import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:games_app/screens/videogame_details.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/videogames_provider.dart';

class TopRatedWidget extends ConsumerWidget {
  const TopRatedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topRatedGames = ref.read(videogamesProvider.notifier).topRatedGames;

    return topRatedGames.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Top 5 Rated Games',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 360,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topRatedGames.length,
                      itemBuilder: (context, index) {
                        final game = topRatedGames[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  VideogameDetails(videogame: game),
                            ));
                          },
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(
                              game.title,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Row(
                              children: [
                                Text(game.rating.toString()),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                            trailing: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: game.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
