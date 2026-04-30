import 'package:startup_launch/features/reader/domain/repositories/reader_repository.dart';

class GetReaderChapterUseCase {
  final ReaderRepository repository;

  GetReaderChapterUseCase(this.repository);

  Future call(String chapterId) {
    return repository.getChapter(chapterId);
  }
}
