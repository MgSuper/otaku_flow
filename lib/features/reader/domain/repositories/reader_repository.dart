import 'package:startup_launch/features/reader/domain/entities/reader_chapter.dart';

abstract class ReaderRepository {
  Future<ReaderChapter> getChapter(String chapterId);
}
