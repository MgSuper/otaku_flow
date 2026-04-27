import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/features/search/data/datasource/onboarding_storage.dart';
import 'package:startup_launch/features/search/domain/usecases/search_manga_usecase.dart';
import 'package:stream_transform/stream_transform.dart';

import 'search_event.dart';
import 'search_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMangaUseCase searchManga;
  final SharedPrefsSearchStorage storage;

  SearchBloc(this.searchManga, this.storage) : super(SearchIdle()) {
    on<SearchSubmitted>(
      _search,
      transformer: (events, mapper) => events
          .debounce(
            const Duration(milliseconds: 500),
          ) // Wait for typing to stop
          .switchMap(mapper),
    );

    on<LoadSearchHistory>(_onLoadHistory);
    on<SearchCleared>(_onClear);
    on<DeleteSearchHistory>(_onDeleteHistory);
  }

  Future<void> _onLoadHistory(
    LoadSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final history = await storage.getRecentSearches();

    emit(SearchIdle(history: history));
  }

  Future<void> _onClear(SearchCleared event, Emitter<SearchState> emit) async {
    final history = await storage.getRecentSearches();
    emit(SearchIdle(history: history));
  }

  Future<void> _search(SearchSubmitted event, Emitter<SearchState> emit) async {
    final q = event.query.trim();
    if (q.isEmpty) {
      add(LoadSearchHistory());
      return;
    }

    emit(SearchLoading());

    try {
      final result = await searchManga(q);

      if (result.isEmpty) {
        emit(SearchEmpty());
      } else {
        // ONLY SAVE HERE: When we know the search actually found something
        await storage.saveSearch(q);
        emit(SearchLoaded(result));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onDeleteHistory(
    DeleteSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    await storage.deleteSearch(event.query);
    final history = await storage.getRecentSearches();
    emit(SearchIdle(history: history));
  }
}
