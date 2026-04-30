import '../../../manga/domain/entities/manga.dart';
import 'chapter.dart';

class MangaDetail {
  final Manga manga;
  final List<Chapter> chapters;
  final int totalPages;

  const MangaDetail({
    required this.manga,
    required this.chapters,
    required this.totalPages,
  });
}
