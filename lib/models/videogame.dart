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
    return Videogame(
      id: json['id'],
      title: json['name'],
      releaseDate: json['released'],
      imageUrl: json['background_image'],
      rating: json['rating'].toDouble(),
    );
  }
}
