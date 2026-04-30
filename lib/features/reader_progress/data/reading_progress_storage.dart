import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_launch/features/reader_progress/domain/entities/reading_progress.dart';

class ReadingProgressStorage {
  final SharedPreferences prefs;

  ReadingProgressStorage(this.prefs);

  static const _key = 'reading_progress';

  Future<void> save(ReadingProgress item) async {
    final json = {
      'mangaId': item.mangaId,
      'mangaTitle': item.mangaTitle,
      'coverUrl': item.coverUrl,
      'chapterId': item.chapterId,
      'chapterTitle': item.chapterTitle,
      'offset': item.offset,
      'pageIndex': item.pageIndex,
      'page': item.page,
    };

    await prefs.setString(_key, jsonEncode(json));
  }

  ReadingProgress? get() {
    final raw = prefs.getString(_key);

    if (raw == null) {
      return null;
    }

    final json = jsonDecode(raw);

    return ReadingProgress(
      mangaId: json['mangaId'],
      mangaTitle: json['mangaTitle'],
      coverUrl: json['coverUrl'],
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      offset: (json['offset'] as num).toDouble(),
      pageIndex: json['pageIndex'] ?? 0,
      page: json['page'] ?? 1,
    );
  }

  Future<void> clear() async {
    await prefs.remove(_key);
  }
}
