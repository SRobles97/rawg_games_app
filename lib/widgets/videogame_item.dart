import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/videogame.dart';

class VideogameItem extends StatelessWidget {
  final Videogame videogame;
  final bool isGrid;

  const VideogameItem({super.key, required this.videogame, this.isGrid = true});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget image = FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(videogame.imageUrl),
        fit: BoxFit.cover,
        width: isGrid
            ? double.infinity
            : width > 600
                ? 400
                : 150,
        height: isGrid
            ? double.infinity
            : width > 600
                ? 300
                : 200);

    Widget buildRowOfStars(double rating) {
      int totalStars = 5;
      List<Widget> stars = List.generate(
          totalStars,
          (index) => const Icon(
                Icons.star_outline,
                color: Colors.amber,
                size: 16,
              ));
      int fullStars = rating.floor();
      for (int i = 0; i < fullStars; i++) {
        stars[i] = const Icon(
          Icons.star,
          color: Colors.amber,
          size: 16,
        );
      }

      double decimalPart = rating - fullStars;
      if (decimalPart >= 0.75) {
        if (fullStars < totalStars) {
          stars[fullStars] = const Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          );
        }
      } else if (decimalPart >= 0.25) {
        if (fullStars < totalStars) {
          stars[fullStars] = const Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 16,
          );
        }
      }

      return Row(mainAxisSize: MainAxisSize.min, children: stars);
    }

    return isGrid
        ? ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                image,
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            videogame.rating.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                        ],
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      videogame.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Card(
            child: Row(
            children: <Widget>[
              image,
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: width > 600
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      videogame.title,
                      style: TextStyle(
                        fontSize: width > 600 ? 23 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Release Date: ${videogame.releaseDate}',
                      style: TextStyle(
                        fontSize: width > 600 ? 18 : 14,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${videogame.rating}',
                          style: TextStyle(
                            fontSize: width > 600 ? 18 : 14,
                          ),
                        ),
                        buildRowOfStars(videogame.rating),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ));
  }
}
