class AnimeModel {
  final int id;
  final String title;
  final String englishTitle;
  final String synopsis;
  final int episodes;
  final String imageUrl;
  final double rating;
  final String status;
  final String source;
  AnimeModel({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.synopsis,
    required this.episodes,
    required this.imageUrl,
    required this.rating,
    required this.status,
    required this.source,
  });
  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      englishTitle: json['title_english'] ?? '',
      synopsis: json['synopsis'] ?? '',
      episodes: json['episodes'] ?? 0,
      imageUrl: json['images']['jpg']['large_image_url'] ?? '',
      rating: json['score'] ?? 0.0,
      status: json['status'] ?? '',
      source: json['source'] ?? '',
    );
  }
}
