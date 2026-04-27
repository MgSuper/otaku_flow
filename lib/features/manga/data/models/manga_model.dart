import 'package:startup_launch/features/manga/domain/entities/manga.dart';

class MangaModel extends Manga {
  const MangaModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.year,
    required super.coverUrl,
    required super.genres,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];

    final attributes = json['attributes'] ?? {};
    final relationships = json['relationships'] ?? [];

    final titleMap = attributes['title'] ?? {};
    final descMap = attributes['description'] ?? {};

    final title =
        titleMap['en'] ??
        (titleMap.values.isNotEmpty
            ? titleMap.values.first as String
            : 'Unknown');

    final description =
        descMap['en'] ??
        (descMap.values.isNotEmpty ? descMap.values.first as String : '');

    final status = attributes['status'] ?? 'unknown';
    final year = attributes['year'];

    final tags = (attributes['tags'] as List? ?? [])
        .map((tag) {
          final name = tag['attributes']?['name'];
          if (name == null) return null;

          return name['en'] ??
              (name.values.isNotEmpty ? name.values.first as String : '');
        })
        .whereType<String>()
        .toList();

    String fileName = '';

    for (final item in relationships) {
      if (item['type'] == 'cover_art') {
        fileName = item['attributes']?['fileName'] ?? '';
      }
    }

    final coverUrl = fileName.isEmpty
        ? ''
        : 'https://uploads.mangadex.org/covers/$id/$fileName.256.jpg';

    return MangaModel(
      id: id,
      title: title,
      description: description,
      status: status,
      year: year,
      coverUrl: coverUrl,
      genres: tags,
    );
  }

  static List<MangaModel> fromList(List list) {
    return list.map((e) => MangaModel.fromJson(e)).toList();
  }
}
