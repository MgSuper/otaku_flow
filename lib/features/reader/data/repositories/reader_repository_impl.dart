import 'package:startup_launch/features/reader/data/datasource/reader_remote_data_source.dart';
import 'package:startup_launch/features/reader/domain/entities/reader_chapter.dart';
import 'package:startup_launch/features/reader/domain/repositories/reader_repository.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final ReaderRemoteDataSource remote;

  ReaderRepositoryImpl(this.remote);

  @override
  Future<ReaderChapter> getChapter(String chapterId) {
    return remote.getChapter(chapterId);
  }
}
