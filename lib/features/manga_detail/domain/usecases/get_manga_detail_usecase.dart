import 'package:startup_launch/features/manga_detail/domain/repositories/manga_detail_repository.dart';

class GetMangaDetailUseCase {
  final MangaDetailRepository repository;

  GetMangaDetailUseCase(this.repository);

  Future call({required String mangaId, required int page}) {
    return repository.getDetail(mangaId: mangaId, page: page);
  }
}
