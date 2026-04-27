import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsSearchStorage {
  final SharedPreferences _prefs;
  static const _key = 'recent_searches';

  SharedPrefsSearchStorage(this._prefs);

  Future<List<String>> getRecentSearches() async {
    return _prefs.getStringList(_key) ?? [];
  }

  Future<void> saveSearch(String query) async {
    final history = await getRecentSearches();

    // 1. Remove exact duplicates
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());

    // 2. Remove fragments of this new query
    // Example: if saving "One Piece", remove "One" and "One Pie"
    history.removeWhere(
      (item) => query.toLowerCase().startsWith(item.toLowerCase()),
    );

    // 3. Add to the front
    history.insert(0, query);

    // 4. Keep it at a reasonable limit (e.g., 10 items)
    if (history.length > 10) history.removeLast();

    await _prefs.setStringList(_key, history);
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_key);
  }

  Future<void> deleteSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];

    history.remove(query);

    await prefs.setStringList(_key, history);
  }
}
