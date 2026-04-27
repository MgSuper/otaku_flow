import 'package:startup_launch/features/manga/domain/entities/manga.dart';

abstract class SearchRepository {
  Future<List<Manga>> search(String query);
}
