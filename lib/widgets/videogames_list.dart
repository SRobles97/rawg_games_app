import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/videogame.dart';

class VideogameList extends StatelessWidget {
  final List<Videogame> videogames;
  final ScrollController scrollController;

  const VideogameList(
      {super.key, required this.videogames, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
      controller: scrollController,
      key: const PageStorageKey('videogames_list'),
      itemBuilder: (context, index) {
        return Card(
            child: Row(
          children: <Widget>[
            FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(videogames[index].imageUrl),
                fit: BoxFit.cover,
                width: width > 600 ? 400 : 150,
                height: width > 600 ? 300 : 200),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: width > 600
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    videogames[index].title,
                    style: TextStyle(
                      fontSize: width > 600 ? 23 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Release Date: ${videogames[index].releaseDate}',
                    style: TextStyle(
                      fontSize: width > 600 ? 18 : 14,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${videogames[index].rating}',
                        style: TextStyle(
                          fontSize: width > 600 ? 18 : 14,
                        ),
                      ),
                      const Icon(Icons.star, color: Colors.amber),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
      },
      itemCount: videogames.length,
    );
  }
}
