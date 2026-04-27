import 'package:startup_launch/features/manga/data/models/manga_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<MangaModel>> search(String query);
}
