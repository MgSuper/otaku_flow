import 'package:startup_launch/features/manga/domain/entities/manga.dart';
import 'package:startup_launch/features/search/domain/repositories/search_repository.dart';

class SearchMangaUseCase {
  final SearchRepository repository;

  SearchMangaUseCase(this.repository);

  Future<List<Manga>> call(String query, {int offset = 0}) {
    return repository.search(query, offset: offset);
  }
}
