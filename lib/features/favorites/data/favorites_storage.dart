import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_launch/features/favorites/domain/entities/favorite_manga.dart';

class FavoritesStorage {
  final SharedPreferences prefs;

  FavoritesStorage(this.prefs);

  static const key = 'favorites';

  List<FavoriteManga> getAll() {
    final raw = prefs.getStringList(key) ?? [];

    return raw.map((e) {
      final json = jsonDecode(e);

      return FavoriteManga(
        id: json['id'],
        title: json['title'],
        coverUrl: json['coverUrl'],
      );
    }).toList();
  }

  Future<void> saveAll(List<FavoriteManga> list) async {
    final data = list.map((e) {
      return jsonEncode({'id': e.id, 'title': e.title, 'coverUrl': e.coverUrl});
    }).toList();

    await prefs.setStringList(key, data);
  }
}
