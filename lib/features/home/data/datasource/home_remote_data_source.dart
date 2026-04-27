import 'package:startup_launch/features/manga/data/models/manga_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MangaModel>> getTrending();
  Future<List<MangaModel>> getLatest();
  Future<List<MangaModel>> getPopular();
}
