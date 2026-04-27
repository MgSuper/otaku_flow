class Manga {
  final String id;
  final String title;
  final String description;
  final String status;
  final int? year;
  final String coverUrl;
  final List<String> genres;

  const Manga({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.year,
    required this.coverUrl,
    required this.genres,
  });
}
