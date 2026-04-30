import 'package:startup_launch/features/manga_detail/data/models/manga_detail_model.dart';

abstract class MangaDetailRemoteDataSource {
  Future<MangaDetailModel> getDetail({
    required String mangaId,
    required int page,
  });
}
