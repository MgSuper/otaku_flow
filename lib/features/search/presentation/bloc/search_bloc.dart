import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/features/search/data/datasource/onboarding_storage.dart';
import 'package:startup_launch/features/search/domain/usecases/search_manga_usecase.dart';
import 'package:stream_transform/stream_transform.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMangaUseCase searchManga;

  final SharedPrefsSearchStorage storage;

  SearchBloc(this.searchManga, this.storage) : super(SearchIdle()) {
    on<SearchSubmitted>(
      _search,
      transformer: (events, mapper) =>
          events.debounce(const Duration(milliseconds: 500)).switchMap(mapper),
    );

    on<SearchLoadMore>(_loadMore);

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
      final result = await searchManga(q, offset: 0);

      if (result.isEmpty) {
        emit(SearchEmpty());
      } else {
        await storage.saveSearch(q);

        emit(
          SearchLoaded(query: q, mangas: result, hasMore: result.length == 20),
        );
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _loadMore(
    SearchLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;

    if (current is! SearchLoaded) {
      return;
    }

    if (!current.hasMore || current.loadingMore) {
      return;
    }

    emit(current.copyWith(loadingMore: true));

    try {
      final result = await searchManga(
        current.query,
        offset: current.mangas.length,
      );

      emit(
        current.copyWith(
          mangas: [...current.mangas, ...result],
          hasMore: result.length == 20,
          loadingMore: false,
        ),
      );
    } catch (_) {
      emit(current.copyWith(loadingMore: false));
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
