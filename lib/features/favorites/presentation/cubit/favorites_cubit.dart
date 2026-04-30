import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/features/favorites/data/favorites_storage.dart';
import 'package:startup_launch/features/favorites/domain/entities/favorite_manga.dart';

class FavoritesCubit extends Cubit<List<FavoriteManga>> {
  final FavoritesStorage storage;

  FavoritesCubit(this.storage) : super([]) {
    load();
  }

  void load() {
    emit(storage.getAll());
  }

  Future<void> toggle(FavoriteManga item) async {
    final list = [...state];

    final exists = list.any((e) => e.id == item.id);

    if (exists) {
      list.removeWhere((e) => e.id == item.id);
    } else {
      list.add(item);
    }

    await storage.saveAll(list);

    emit(list);
  }

  bool isFavorite(String id) {
    return state.any((e) => e.id == id);
  }
}
