import 'package:startup_launch/features/manga/domain/entities/manga.dart';
import 'package:startup_launch/features/search/data/datasource/search_remote_data_source.dart';
import 'package:startup_launch/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remote;

  SearchRepositoryImpl(this.remote);

  @override
  Future<List<Manga>> search(String query, {int offset = 0}) {
    return remote.search(query, offset: offset);
  }
}
