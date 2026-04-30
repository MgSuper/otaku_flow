import 'package:startup_launch/features/manga_detail/domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    required super.chapter,
    required super.title,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    final attr = json['attributes'];
    return ChapterModel(
      id: json['id'],
      chapter: attr['chapter'] ?? '?',
      title: attr['title'] ?? '',
    );
  }

  static List<ChapterModel> fromList(List list) {
    return list.map((e) => ChapterModel.fromJson(e)).toList();
  }
}
