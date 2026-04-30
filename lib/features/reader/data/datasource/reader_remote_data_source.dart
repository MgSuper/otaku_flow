import 'package:startup_launch/features/reader/data/models/reader_chapter_model.dart';

abstract class ReaderRemoteDataSource {
  Future<ReaderChapterModel> getChapter(String chapterId);
}
