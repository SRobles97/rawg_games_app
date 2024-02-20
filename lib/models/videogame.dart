class Videogame {
  final int id;
  final String title;
  final String releaseDate;
  final String imageUrl;
  final double rating;

  Videogame(
      {required this.id,
      required this.title,
      required this.releaseDate,
      required this.imageUrl,
      required this.rating});

  factory Videogame.fromJson(Map<String, dynamic> json) {
    String fixedName(String name) {
      return name.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    }

    return Videogame(
      id: json['id'],
      title: fixedName(json['name']),
      releaseDate: json['released'],
      imageUrl: json['background_image'],
      rating: json['rating'].toDouble(),
    );
  }
}
