import '../../domain/entities/reader_chapter.dart';

class ReaderChapterModel extends ReaderChapter {
  const ReaderChapterModel({
    required super.chapterId,
    required super.title,
    required super.imageUrls,
  });

  factory ReaderChapterModel.fromJson(
    String chapterId,
    Map<String, dynamic> json,
  ) {
    final baseUrl = json['baseUrl'];

    final chapter = json['chapter'];

    final hash = chapter['hash'];

    if (hash.isEmpty ||
        ((chapter['data'] == null || (chapter['data'] as List).isEmpty) &&
            (chapter['dataSaver'] == null) &&
            (chapter['dataSaver'] as List).isEmpty)) {
      throw Exception('This chapter is not available from current source.');
    }

    final useSaver =
        chapter['data'] == null || (chapter['data'] as List).isEmpty;

    final pages = useSaver ? chapter['dataSaver'] : chapter['data'];

    final folder = useSaver ? 'data-saver' : 'data';

    final urls = pages.map((file) {
      return '$baseUrl/$folder/$hash/$file';
    }).toList();

    return ReaderChapterModel(
      chapterId: chapterId,
      title: 'Chapter',
      imageUrls: urls.cast<String>(),
    );
  }
}
