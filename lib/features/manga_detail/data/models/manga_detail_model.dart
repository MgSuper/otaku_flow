import 'package:startup_launch/features/manga/data/models/manga_model.dart';
import 'package:startup_launch/features/manga_detail/data/models/chapter_model.dart';
import 'package:startup_launch/features/manga_detail/domain/entities/manga_detail.dart';

class MangaDetailModel extends MangaDetail {
  const MangaDetailModel({
    required super.manga,
    required super.chapters,
    required super.totalPages,
  });

  factory MangaDetailModel.fromJson({
    required Map<String, dynamic> mangaJson,
    required List chaptersJson,
    required int totalPages,
  }) {
    return MangaDetailModel(
      manga: MangaModel.fromJson(mangaJson),
      chapters: ChapterModel.fromList(chaptersJson),
      totalPages: totalPages,
    );
  }
}
