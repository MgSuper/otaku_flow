import 'package:startup_launch/features/manga_detail/domain/entities/manga_detail.dart';

abstract class MangaDetailRepository {
  Future<MangaDetail> getDetail({required String mangaId, required int page});
}
