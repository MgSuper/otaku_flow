import 'package:startup_launch/features/manga_detail/data/datasource/manga_detail_remote_data_source.dart';
import 'package:startup_launch/features/manga_detail/domain/entities/manga_detail.dart';
import 'package:startup_launch/features/manga_detail/domain/repositories/manga_detail_repository.dart';

class MangaDetailRepositoryImpl implements MangaDetailRepository {
  final MangaDetailRemoteDataSource remote;

  MangaDetailRepositoryImpl(this.remote);

  @override
  Future<MangaDetail> getDetail({required String mangaId, required int page}) {
    return remote.getDetail(mangaId: mangaId, page: page);
  }
}
