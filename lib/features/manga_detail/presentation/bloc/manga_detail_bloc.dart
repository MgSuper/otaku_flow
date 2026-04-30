import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_launch/features/manga_detail/domain/usecases/get_manga_detail_usecase.dart';
import 'package:startup_launch/features/manga_detail/presentation/bloc/manga_detail_event.dart';
import 'package:startup_launch/features/manga_detail/presentation/bloc/manga_detail_state.dart';

class MangaDetailBloc extends Bloc<MangaDetailEvent, MangaDetailState> {
  final GetMangaDetailUseCase getDetail;

  MangaDetailBloc(this.getDetail) : super(MangaDetailLoading()) {
    on<LoadMangaDetail>(_load);

    on<ChangeChapterPage>(_changePage);
  }

  String _mangaId = '';

  Future<void> _load(
    LoadMangaDetail event,
    Emitter<MangaDetailState> emit,
  ) async {
    try {
      debugPrint('-----------------------------------------');
      debugPrint('[MangaDetailBloc] 🏁 Initial Load for: ${event.mangaId}');
      debugPrint(
        '[MangaDetailBloc] Initial Load for event.page : ${event.page}',
      );
      emit(MangaDetailLoading());

      _mangaId = event.mangaId;

      final result = await getDetail(mangaId: _mangaId, page: event.page ?? 1);

      emit(
        MangaDetailLoaded(
          manga: result.manga,
          chapters: result.chapters,
          currentPage: event.page ?? 1,
          totalPages: result.totalPages,
          loadingChapters: false,
        ),
      );
      // 1. Get the current page from the event or the state, not the result
      // PREFETCH LOGIC
      // Since this is page 1, we check if there is a page 2
      if (1 < result.totalPages) {
        debugPrint('[MangaDetailBloc] ⚡ Starting Prefetch for Page 2...');
        // We don't await this so it happens in the background
        unawaited(
          getDetail(mangaId: _mangaId, page: 2).then((_) {
            debugPrint('[MangaDetailBloc] Prefetch for Page 2 Finished.');
          }),
        );
      }
    } catch (e) {
      debugPrint('[MangaDetailBloc] Error in _load: $e');
      emit(MangaDetailError(e.toString()));
    }
  }

  Future<void> _changePage(
    ChangeChapterPage event,
    Emitter<MangaDetailState> emit,
  ) async {
    final current = state as MangaDetailLoaded;

    debugPrint('currentPage: event.page ${event.page}');

    emit(current.copyWith(loadingChapters: true, currentPage: event.page));

    final result = await getDetail(mangaId: _mangaId, page: event.page);

    emit(
      current.copyWith(
        chapters: result.chapters,
        currentPage: event.page,
        totalPages: result.totalPages,
        loadingChapters: false,
      ),
    );
    if (event.page < result.totalPages) {
      debugPrint('[MangaDetailBloc] ⚡ Starting Prefetch for Page 2...');
      unawaited(
        getDetail(mangaId: _mangaId, page: event.page + 1).then((_) {
          debugPrint('[MangaDetailBloc] ✅ Prefetch for Page 2 Finished.');
        }),
      );
    }
  }
}
