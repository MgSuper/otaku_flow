import 'package:startup_launch/features/manga/domain/entities/manga.dart';

class HomeData {
  final List<Manga> trending;
  final List<Manga> latest;
  final List<Manga> popular;

  const HomeData({
    required this.trending,
    required this.latest,
    required this.popular,
  });
}
